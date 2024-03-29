//
//  ScannerController.swift
//  FaceIdScanner
//
//  Created by Julian Hartl on 04.04.21.
//

import Foundation
import UIKit
import AVFoundation
import SceneKit
import VideoToolbox
import CoreGraphics


class ScannerController: NSObject, AVCaptureDataOutputSynchronizerDelegate, AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureFileOutputRecordingDelegate {

    private enum SessionSetupResult {
        case success
        case notAuthorized
        case configurationFailed
    }

    private var setupResult: SessionSetupResult = .success

    private let dataOutputQueue = DispatchQueue(label: "video data queue", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
    private let imageDecodingQueue = DispatchQueue(label: "image decoding queue", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
    private let sessionQueue = DispatchQueue(label: "session queue", attributes: [], autoreleaseFrequency: .workItem)
    private let pointCloudQueue = DispatchQueue(label: "point cloud queue", attributes: [], autoreleaseFrequency: .workItem)
    private let objectDetectionQueue = DispatchQueue(label: "object detection queue", attributes: [], autoreleaseFrequency: .workItem)

    private let session = AVCaptureSession()
    private var videoDeviceInput: AVCaptureDeviceInput!
    public var canUseDepthCamera: Bool!
    private let cameraOptions: CameraOptions!
    private let movieOutput = AVCaptureMovieFileOutput()

    @available(iOS 11.1, *)
    init(cameraOptions: CameraOptions!) {
        self.cameraOptions = cameraOptions

        super.init();
        self.setDeviceDiscoverySession(lensDirection: cameraOptions.lensDirection)

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(handleNotification(_:)), name: .AVCaptureSessionRuntimeError, object: session)

    }

    func changeLensDirection(_ lensDirection: LensDirection) {
        sessionQueue.async {
            self.session.stopRunning()
            self.session.inputs.forEach { input in
                self.session.removeInput(input)
            }
            self.session.outputs.forEach { output in
                self.session.removeOutput(output)
            }
            self.setDeviceDiscoverySession(lensDirection: lensDirection)
            self.configureSession()
            self.session.startRunning()
        }
    }

    fileprivate func setDeviceDiscoverySession(lensDirection: LensDirection) {

    }

    @objc func handleNotification(_ notification: Notification) {
        print(notification.name)
        print(notification.debugDescription)
        guard let error = notification.userInfo?[AVCaptureSessionErrorKey] as? AVError else {
            return
        }

        print(error)
    }

    private let videoDataOutput = AVCaptureVideoDataOutput()
    private let depthDataOutput = AVCaptureDepthDataOutput()
    private var outputSynchronizer: AVCaptureDataOutputSynchronizer?

    private var previewLayer: AVCaptureVideoPreviewLayer?
    private var snapshotCallback: ((FaceIdData, NativeCameraImage) -> Void)?
    private var calibrationCallback: ((AVCameraCalibrationData) -> Void)?
    private var faceIdSensorDataCallback: ((FaceIdData) -> Void)?
    private var depthValuesCallback: (([Float32]) -> Void)?
    private var onObjectCoverageChange: ((ObjectDetectionResult) -> Void)?
    private var onMovieRecordStop: ((URL, Error?) -> Void)?


    func getCalibrationData(_ callback: @escaping (AVCameraCalibrationData) -> Void) {
        calibrationCallback = callback
    }

    func getFaceIdSensorDataSnapshot(_ callback: @escaping (FaceIdData) -> Void) {
        faceIdSensorDataCallback = callback
    }

    func getDepthValuesSnapshot(_ callback: @escaping ([Float32]) -> Void) {
        depthValuesCallback = callback
    }


    /// Returns [FaceIdData] and a [NativeCameraImage] for the next processed frame.
    func getSnapshot(_ callback: @escaping (FaceIdData, NativeCameraImage) -> Void) {

        snapshotCallback = callback
    }

    func setOnObjectCoverageChangeListener(_ callback: @escaping (ObjectDetectionResult) -> Void) {
        onObjectCoverageChange = callback
    }

    func removeOnObjectCoverageChangedListener() {
        onObjectCoverageChange = nil
    }


    /// Starts setup for camera.
    func prepare(_ callback: @escaping (Error?) -> Void) {
        print("prepare")
        sessionQueue.async {
            self.configureSession()
            self.session.startRunning()
            DispatchQueue.main.async {
                print("prepare done")
                print("setupResult: \(self.setupResult)")
                print("session.isRunning: \(self.session.isRunning)")
                callback(nil)
            }
        }
    }

    /// Stops preview.
    func stop(_ callback: ((Error?) -> ())) {
        do {
            previewLayer?.removeFromSuperlayer()
            session.stopRunning()

            previewLayer = nil
            callback(nil)
        } catch let error {
            callback(error);
        }


    }


    /// Displays the camera preview on [view].
    func displayPreview(on view: UIView) throws {
        guard session.isRunning else {
            print("no preview")
            return
        }
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspect
        previewLayer?.connection?.videoOrientation = .portrait

        view.layer.insertSublayer(self.previewLayer!, at: 0)
        previewLayer?.frame = view.frame

    }

    private var bytesCallback: (([String: Any]) -> Void)?;

    /// Returns encoded [NativeCameraImage].
    ///
    /// Useful for devices/orientations which do not support face id.
    func getImageBytes(_ callback: @escaping ([String: Any]) -> Void) -> Void {
        bytesCallback = callback
    }

    private var streamingCallback: (([String: Any]) -> Void)?;
    private var streaming: Bool = false;

    /// Starts an image stream.
    ///
    /// [callback] is called everytime a new frame is processed.
    ///
    /// Argument is an encoded [NativeCameraImage].
    func startStreaming(_ callback: @escaping ([String: Any]) -> Void) -> Void {
        streamingCallback = callback
        streaming = true
    }

    /// Stops the current image stream.
    func stopStreaming() {
        streaming = false
        streamingCallback = nil
    }

    /// Is called on every new frame and is the central entrypoint for image processing.
    ///
    /// Provided by [AVCaptureVideoDataOutputSampleBufferDelegate].
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        imageDecodingQueue.async {
            if (self.bytesCallback != nil) {
                self.bytesCallback!(self.getNativeCameraImage(sampleBuffer: sampleBuffer))
                // check if streaming is true
                self.bytesCallback = nil;

            }
            if (self.streaming) {
                self.streamingCallback!(self.getNativeCameraImage(sampleBuffer: sampleBuffer))

            }
        }

    }

    /// Is called on every new frame and is the central entrypoint for image processing.
    ///
    /// Provided by [AVCaptureDataOutputSynchronizerDelegate].
    ///
    /// Is used when depth data is needed.
    func dataOutputSynchronizer(_ synchronizer: AVCaptureDataOutputSynchronizer,
                                didOutput synchronizedDataCollection: AVCaptureSynchronizedDataCollection) {
        // Use DispatchQueues here to prevent heavy processing from happening on main/ui thread.
        imageDecodingQueue.async {
            guard let syncedDepthData: AVCaptureSynchronizedDepthData =
            synchronizedDataCollection.synchronizedData(for: self.depthDataOutput) as? AVCaptureSynchronizedDepthData,
                  let syncedVideoData: AVCaptureSynchronizedSampleBufferData =
                  synchronizedDataCollection.synchronizedData(for: self.videoDataOutput) as? AVCaptureSynchronizedSampleBufferData
            else {
                return
            }

            let depthData = syncedDepthData.depthData

            let sampleBuffer = syncedVideoData.sampleBuffer
            guard let videoPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
                return
            }

            guard let depthValues = depthData.depthDataMap.depthValues() else {
                return
            }


            if (self.onObjectCoverageChange != nil) {
                self.objectDetectionQueue.async {
                    let width = CVPixelBufferGetWidth(depthData.depthDataMap)
                    let height = CVPixelBufferGetHeight(depthData.depthDataMap)
                    let result = self.checkForObject(depthValues: depthValues, width: width, height: height)
                    if (self.onObjectCoverageChange != nil) {
                        self.onObjectCoverageChange!(result)
                    }
                }
            }

            if (self.depthValuesCallback != nil) {
                self.depthValuesCallback!(depthValues)
            }

            if (self.bytesCallback != nil) {
                self.bytesCallback!(self.getNativeCameraImage(sampleBuffer: sampleBuffer))
                self.bytesCallback = nil

            }

            if (self.calibrationCallback != nil) {
                self.calibrationCallback!(depthData.cameraCalibrationData!)
                self.calibrationCallback = nil
            }

            if (self.streaming) {
                self.streamingCallback!(self.getNativeCameraImage(sampleBuffer: sampleBuffer))
            }

            if (self.snapshotCallback != nil || self.faceIdSensorDataCallback != nil) {
                self.pointCloudQueue.async {
                    var cgImage: CGImage?
                    VTCreateCGImageFromCVPixelBuffer(videoPixelBuffer, options: nil, imageOut: &cgImage)
                    self.getPointCloud(depthData: depthData, cgColorImage: cgImage!, sampleBuffer: sampleBuffer)
                }

            }
        }
    }

    func checkForObject(depthValues: [Float32], width: Int, height: Int) -> ObjectDetectionResult {
        let detectionOptions = cameraOptions.objectDetectionOptions
        let widthRange = Int(Double(width) * detectionOptions.centerHeightStart)...Int(Double(width) * detectionOptions.centerWidthEnd)
        let heightRange = Int(Double(height) * detectionOptions.centerHeightStart)...Int(Double(height) * detectionOptions.centerHeightEnd)
        let centerCount = (widthRange.upperBound - widthRange.lowerBound) * (heightRange.upperBound - heightRange.lowerBound)
        let depthRange = detectionOptions.minDepth...detectionOptions.maxDepth
        var result = ObjectDetectionResult(
                belowLowerBound: 0,
                aboveUpperBound: 0,
                leftOfBound: 0,
                rightOfBound: 0,
                aboveBound: 0,
                belowBound: 0,
                insideBound: 0,
                boundPointCount: centerCount
        );


        for (i, raw) in depthValues.enumerated() {
            let x = i % width
            let y = i / width
            let value = Double(raw);

            if (widthRange.contains(x) && heightRange.contains(y)) {
                if (depthRange.contains(value)) {
                    result.insideBound += 1;
                } else {
                    if (value < depthRange.lowerBound) {
                        result.belowLowerBound += 1;
                    } else if (value > depthRange.upperBound && value < depthRange.upperBound * 1.5) {
                        result.aboveUpperBound += 1;
                    }
                }

            } else {
                if (!depthRange.contains(value)) {
                    continue;
                }
                if (x < widthRange.lowerBound) {
                    result.leftOfBound += 1;
                } else if (x > widthRange.upperBound) {
                    result.rightOfBound += 1;
                }
                if (y < heightRange.lowerBound) {
                    result.belowBound += 1;
                } else if (y > heightRange.upperBound) {
                    result.aboveBound += 1;
                }
            }

        }

        return result;
    }


    /// Decodes an array of [Plane].
    private func decodePlanes(planes: [NSDictionary]) -> [Plane] {
        planes.map({
            plane in
            Plane(width: plane["width"] as! Int, height: plane["height"] as! Int, bytes: (plane["bytes"] as! Data).bytes, bytesPerRow: plane["bytesPerRow"] as! Int)
        })
    }

    /// Returns an encoded [NativeCamera] from a [CMSampleBuffer].
    private func getNativeCameraImage(sampleBuffer: CMSampleBuffer) -> [String: Any] {


        let encoded = ScannerControllerUtils.convertSampleBuffer(toNativeImage: sampleBuffer)

        return encoded as! [String: Any];

    }


    /// Gets a cloud of points for current image frame.
    ///
    /// Useful for hand measurements.
    func getPointCloud(depthData: AVDepthData, cgColorImage: CGImage, sampleBuffer: CMSampleBuffer) {
        let copiedSnapshotCallback = snapshotCallback
        let copiedFaceIdSensorDataCallback = faceIdSensorDataCallback
        snapshotCallback = nil
        faceIdSensorDataCallback = nil
        let depthPixelBuffer = depthData.depthDataMap
        let depthWidth = CVPixelBufferGetWidth(depthPixelBuffer)
        let depthHeight = CVPixelBufferGetHeight(depthPixelBuffer)


        var undistortedBuffer: CVPixelBuffer? = nil
        if (cameraOptions.enableDistortionCorrection) {
            undistortedBuffer = undistortDepthValues(depthPixelBuffer: depthPixelBuffer, depthData: depthData, depthWidth: depthWidth, depthHeight: depthHeight)
        }


        let depthValues: [Float32]? = (undistortedBuffer ?? depthPixelBuffer).depthValues()
        guard let depthValues = depthValues else {
            return
        }

        guard let cameraCalibrationData = depthData.cameraCalibrationData else {
            return
        }


        let faceIdData = convertRGBDtoXYZ(colorImage: cgColorImage, depthValues: depthValues, depthWidth: depthWidth, depthHeight: depthHeight, cameraCalibrationData: cameraCalibrationData)
        if (copiedFaceIdSensorDataCallback != nil) {
            copiedFaceIdSensorDataCallback!(faceIdData)
        }
        if (copiedSnapshotCallback != nil) {
            copiedSnapshotCallback!(faceIdData, decodeNativeCameraImage(getNativeCameraImage(sampleBuffer: sampleBuffer)))
        }

    }

    private func undistortDepthValues(depthPixelBuffer: CVPixelBuffer, depthData: AVDepthData, depthWidth: Int, depthHeight: Int) -> CVPixelBuffer? {
        // Undistort depth data using lensDistortionPointForPoint
        var maybePixelBuffer: CVPixelBuffer? = nil
        let format = CVPixelBufferGetPixelFormatType(depthPixelBuffer)
//        assert(format == kCVPixelFormatType_420YpCbCr8Planar)
        let status = CVPixelBufferCreate(nil, depthWidth, depthHeight, format, nil, &maybePixelBuffer)
        guard status == kCVReturnSuccess, let undistortedBuffer = maybePixelBuffer else {
            return nil
        }
        CVPixelBufferLockBaseAddress(depthPixelBuffer, .readOnly)
        CVPixelBufferLockBaseAddress(undistortedBuffer, CVPixelBufferLockFlags(rawValue: 0))
        // map every point in depthPixelBuffer to undistortedBuffer using lensDistortionPointForPoint
        let lensDistortionLookupTable = depthData.cameraCalibrationData!.lensDistortionLookupTable!
        let opticalCenter = depthData.cameraCalibrationData!.lensDistortionCenter
        print("opticalCenter \(opticalCenter)")
        var changedPixelCount = 0
        let depthImageSize = CGSize(width: depthWidth, height: depthHeight)


        let source = CVPixelBufferGetBaseAddressOfPlane(depthPixelBuffer, 0)
        let height = CVPixelBufferGetHeightOfPlane(depthPixelBuffer, 0)
        let width = CVPixelBufferGetWidthOfPlane(depthPixelBuffer, 0)
        let bytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(depthPixelBuffer, 0)

        let destination = CVPixelBufferGetBaseAddressOfPlane(undistortedBuffer, 0)

        // loop over all points in plane
        for y in 0..<height {

            for x in 0..<width {
                let offset = y * bytesPerRow + x * MemoryLayout<UInt8>.stride
                let sourcePointer = source!.advanced(by: offset).assumingMemoryBound(to: UInt8.self)
                let point = CGPoint(x: CGFloat(x), y: CGFloat(y))
                let undistortedPoint = lensDistortionPoint(
                        for: point,
                        lookupTable: lensDistortionLookupTable,
                        distortionOpticalCenter: opticalCenter,
                        imageSize: depthImageSize
                )
                let undistortedX = Int(undistortedPoint.x)
                let undistortedY = Int(undistortedPoint.y)
                let destinationOffset = undistortedY * bytesPerRow + undistortedX * MemoryLayout<UInt8>.stride
                if (destinationOffset >= bytesPerRow * height) {
                    //todo: handle this
                    continue
                }
                if (destinationOffset != offset) {
                    changedPixelCount += 1
                }
                let destinationPointer = destination!.advanced(by: destinationOffset).assumingMemoryBound(to: UInt8.self)
                destinationPointer.pointee = sourcePointer.pointee
            }
        }
        print("Changed \(changedPixelCount) pixels out of \(depthWidth * depthHeight) pixels after undistortion.")

        CVPixelBufferUnlockBaseAddress(depthPixelBuffer, .readOnly)
        CVPixelBufferUnlockBaseAddress(undistortedBuffer, CVPixelBufferLockFlags(rawValue: 0))
        return undistortedBuffer
    }

    func lensDistortionPoint(for point: CGPoint, lookupTable: Data, distortionOpticalCenter opticalCenter: CGPoint, imageSize: CGSize) -> CGPoint {
        // The lookup table holds the relative radial magnification for n linearly spaced radii.
        // The first position corresponds to radius = 0
        // The last position corresponds to the largest radius found in the image.

        // Determine the maximum radius.
        let delta_ocx_max = Float(max(opticalCenter.x, imageSize.width - opticalCenter.x))
        let delta_ocy_max = Float(max(opticalCenter.y, imageSize.height - opticalCenter.y))
        let r_max = sqrt(delta_ocx_max * delta_ocx_max + delta_ocy_max * delta_ocy_max)

        // Determine the vector from the optical center to the given point.
        let v_point_x = Float(point.x - opticalCenter.x)
        let v_point_y = Float(point.y - opticalCenter.y)

        // Determine the radius of the given point.
        let r_point = sqrt(v_point_x * v_point_x + v_point_y * v_point_y)

        // Look up the relative radial magnification to apply in the provided lookup table
        let magnification: Float = lookupTable.withUnsafeBytes { (lookupTableValues: UnsafePointer<Float>) in
            let lookupTableCount = lookupTable.count / MemoryLayout<Float>.size

            if r_point < r_max {
                // Linear interpolation
                let val = r_point * Float(lookupTableCount - 1) / r_max
                let idx = Int(val)
                let frac = val - Float(idx)

                let mag_1 = lookupTableValues[idx]
                let mag_2 = lookupTableValues[idx + 1]

                return (1.0 - frac) * mag_1 + frac * mag_2
            } else {
                return lookupTableValues[lookupTableCount - 1]
            }
        }

        // Apply radial magnification
        let new_v_point_x = v_point_x + magnification * v_point_x
        let new_v_point_y = v_point_y + magnification * v_point_y

        // Construct output
        return CGPoint(x: opticalCenter.x + CGFloat(new_v_point_x), y: opticalCenter.y + CGFloat(new_v_point_y))
    }

    /// Returns a decoded [NativeCameraImage] from a Map.
    func decodeNativeCameraImage(_ encoded: [String: Any]) -> NativeCameraImage {
        NativeCameraImage(planes: decodePlanes(planes: encoded["planes"] as! [NSDictionary]), height: encoded["height"] as! Int, width: encoded["width"] as! Int)
    }

    func convertRGBDtoXYZ(colorImage: CGImage, depthValues: [Float32], depthWidth: Int, depthHeight: Int, cameraCalibrationData: AVCameraCalibrationData) -> FaceIdData {

        var intrinsics = cameraCalibrationData.intrinsicMatrix
        let referenceDimensions = cameraCalibrationData.intrinsicMatrixReferenceDimensions
        let ratio = Float(referenceDimensions.width) / Float(depthWidth)
        intrinsics.columns.0[0] /= ratio
        intrinsics.columns.1[1] /= ratio
        intrinsics.columns.2[0] /= ratio
        intrinsics.columns.2[1] /= ratio


        let imgBytes = CFDataGetBytePtr(colorImage.dataProvider?.data)!

        var rgb = [[UInt8]](repeating: [UInt8](repeating: 0, count: 3), count: depthValues.count)
        let xyz: [[Float32]] = depthValues.enumerated().map {
            let z = Float($0.element)
            let index = $0.offset
            let u = Float(index % depthWidth)
            let v = Float(index / depthWidth)
            rgb[index][0] = imgBytes[index * 4]
            rgb[index][1] = imgBytes[index * 4 + 1]
            rgb[index][2] = imgBytes[index * 4 + 2]
            let x = (u - intrinsics.columns.2[0]) * z / intrinsics.columns.0[0];
            let y = (v - intrinsics.columns.2[1]) * z / intrinsics.columns.1[1];
            return [x, y, z]
        }

        return FaceIdData(XYZ: xyz, RGB: rgb, depthValues: depthValues, width: Int32(depthWidth), height: Int32(depthHeight), cameraCalibrationData: cameraCalibrationData)
    }


    /// Sets up current capture session.
    private func configureSession() {

        let resolver = DeviceConstraintResolver(cameraOptions: cameraOptions)
        let resolveDeviceResult: (AVCaptureDevice, AVCaptureDevice.Format, AVFrameRateRange)? = resolver.solve()
        print("\(resolveDeviceResult)")
        guard let (videoDevice, format, frameRateRange) = resolveDeviceResult else {
            print("Could not find any video device.")
            return
        }

        print("Formats: \(format.supportedDepthDataFormats)")
        canUseDepthCamera = !format.supportedDepthDataFormats.isEmpty
        if (!canUseDepthCamera && cameraOptions.useDepthCamera) {
            print("Depth camera is not available.")
        }

        do {
            videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
        } catch {
            print("Could not create video device input: \(error)")
            setupResult = .configurationFailed
            return
        }


        session.beginConfiguration()
        switch cameraOptions.preferredResolution {
        case .x1920x1080:
            session.sessionPreset = AVCaptureSession.Preset.hd1920x1080
        case .x640x480:
            session.sessionPreset = AVCaptureSession.Preset.vga640x480
        }
        // Add a video input
        guard session.canAddInput(videoDeviceInput) else {
            print("Could not add video device input to the session")
            setupResult = .configurationFailed
            session.commitConfiguration()
            return
        }
        session.addInput(videoDeviceInput)

        do {
            try videoDevice.lockForConfiguration()
            videoDevice.activeFormat = format
            videoDevice.activeVideoMinFrameDuration = frameRateRange.minFrameDuration
            videoDevice.activeVideoMaxFrameDuration = frameRateRange.minFrameDuration

            videoDevice.unlockForConfiguration()
        } catch {
            print("Could not lock device for configuration: \(error)")
            setupResult = .configurationFailed
            return
        }

        print("Using camera: \(videoDevice.localizedName) with format: \(videoDevice.activeFormat)")

        // Add a video data output
        if session.canAddOutput(videoDataOutput) {
            session.addOutput(videoDataOutput)
            videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
        } else {
            print("Could not add video data output to the session")
            setupResult = .configurationFailed
            session.commitConfiguration()
            return
        }

        if (session.canAddOutput(movieOutput)) {
            session.addOutput(movieOutput)
        } else {
            print("Could not add movieOutput to the session")
        }

        // Configuration needs to be different in order to use the depth camera.
        if (canUseDepthCamera) {

            // Add a depth data output
            if session.canAddOutput(depthDataOutput) {
                session.addOutput(depthDataOutput)
                depthDataOutput.isFilteringEnabled = false
                if let connection = depthDataOutput.connection(with: .depthData) {
                    connection.isEnabled = true
                } else {
                    print("No AVCaptureConnection")
                }
            } else {
                print("Could not add depth data output to the session")
                setupResult = .configurationFailed
                session.commitConfiguration()
                return
            }

            // Search for highest resolution with half-point depth values
            let depthFormats = videoDevice.activeFormat.supportedDepthDataFormats
            let filtered = depthFormats.filter({
                CMFormatDescriptionGetMediaSubType($0.formatDescription) == kCVPixelFormatType_DepthFloat16
            })
            let selectedFormat = filtered.max(by: {
                first, second in
                CMVideoFormatDescriptionGetDimensions(first.formatDescription).width < CMVideoFormatDescriptionGetDimensions(second.formatDescription).width
            })

            do {
                try videoDevice.lockForConfiguration()
                videoDevice.activeDepthDataFormat = selectedFormat
                videoDevice.unlockForConfiguration()
            } catch {
                print("Could not lock device for configuration: \(error)")
                setupResult = .configurationFailed
                session.commitConfiguration()
                return
            }

            // Use an AVCaptureDataOutputSynchronizer to synchronize the video data and depth data outputs.
            // The first output in the dataOutputs array, in this case the AVCaptureVideoDataOutput, is the "master" output.
            outputSynchronizer = AVCaptureDataOutputSynchronizer(dataOutputs: [videoDataOutput, depthDataOutput])
            outputSynchronizer!.setDelegate(self, queue: dataOutputQueue)
        } else {
            print("Settings sample buffer delegate")
            videoDataOutput.setSampleBufferDelegate(self, queue: dataOutputQueue)
        }
        session.commitConfiguration()
    }

    private func filterDevices(captureDevices: [AVCaptureDevice], preferredFrameRate: PreferredFrameRate) -> AVCaptureDevice? {
        captureDevices.first { device in
            device.formats.contains {
                $0.videoSupportedFrameRateRanges.contains(where: {
                    Int($0.maxFrameRate) >= preferredFrameRate.frameRate()
                })
            }
        }
    }

    func startMovieRecording() {
        let filePath = NSTemporaryDirectory() + "tempMovie.mov"
        let outputURL = URL(fileURLWithPath: filePath)
        do {
            try FileManager.default.removeItem(at: outputURL)
        } catch let error {
            print("Could not remove file: \(error)")
        }
        movieOutput.startRecording(to: outputURL, recordingDelegate: self)
    }

    func stopMovieRecording(
            _ callback: @escaping (URL, Error?) -> Void
    ) {
        onMovieRecordStop = callback
        movieOutput.stopRecording()
    }

    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        print("Finished Recording")
        if let callback = onMovieRecordStop {
            callback(outputFileURL, error)
            onMovieRecordStop = nil
        }
    }
}

class DeviceConstraintResolver {
    private let cameraOptions: CameraOptions!

    init(cameraOptions: CameraOptions!) {
        self.cameraOptions = cameraOptions
    }

    func solve() -> (AVCaptureDevice, AVCaptureDevice.Format, AVFrameRateRange)? {
        let devices = solveForLensDirection()
        var bestFrameRateDiff = Int.max
        var bestResolutionDiff = Int.max
        var result: (AVCaptureDevice, AVCaptureDevice.Format, AVFrameRateRange)?
        for device in devices {
            for format in device.formats {
                let filtered = format.supportedDepthDataFormats.filter({
                    CMFormatDescriptionGetMediaSubType($0.formatDescription) == kCVPixelFormatType_DepthFloat16
                })
                if (filtered.isEmpty && cameraOptions.useDepthCamera) {
                    continue;
                }
                // Calculate resolution difference
                let resolution = CMVideoFormatDescriptionGetDimensions(format.formatDescription)
                let resolutionDiff = calculateResolutionDifference(cameraOptions.preferredResolution, resolution)


                var bestRange: AVFrameRateRange?
                for range in format.videoSupportedFrameRateRanges {
                    let frameRate = Int(range.maxFrameRate)
                    let frameRateDiff = abs(frameRate - cameraOptions.preferredFrameRate.frameRate())
                    if frameRateDiff < bestFrameRateDiff {
                        bestFrameRateDiff = frameRateDiff
                        bestRange = range
                    }
                }

                if resolutionDiff <= bestResolutionDiff && bestRange != nil {
                    bestResolutionDiff = resolutionDiff
                    result = (device, format, bestRange!)
                }

            }
        }

        return result
    }

    func calculateResolutionDifference(_ preferred: PreferredResolution, _ actual: CMVideoDimensions) -> Int {
        return abs(preferred.width() - Int(actual.width)) + abs(preferred.height() - Int(actual.height))
    }

    func solveForLensDirection() -> [AVCaptureDevice] {
        var position: AVCaptureDevice.Position
        var deviceTypes: [AVCaptureDevice.DeviceType]
        // Determine which lensDirection should be used and set the [deviceTypes] accordingly.
        switch (cameraOptions.lensDirection) {
        case .front: position = .front
            if #available(iOS 11.1, *) {
                if (cameraOptions.useDepthCamera) {
                    deviceTypes = [.builtInTrueDepthCamera]
                } else {
                    deviceTypes = [.builtInWideAngleCamera]
                }
            } else {
                print("iOS 11.1 or higher is required for front camera")
                deviceTypes = []
            }
        case .back: position = .back
            // only use lidar when ios version is greater or equal to 15.4

            if #available(iOS 15.4, *) {
                if (cameraOptions.useDepthCamera) {
                    deviceTypes = [.builtInLiDARDepthCamera]
                } else {
                    deviceTypes = [.builtInDualCamera, .builtInTripleCamera, .builtInWideAngleCamera, .builtInDualWideCamera]
                }
            } else {
                if #available(iOS 13.0, *) {
                    deviceTypes = [.builtInDualCamera, .builtInTripleCamera, .builtInWideAngleCamera, .builtInDualWideCamera]
                } else {
                    print("Encountered unsupported ios version 😇")
                    deviceTypes = []
                }
            }

        }
        let videoDeviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: deviceTypes,
                mediaType: .video,
                position: position);


        return videoDeviceDiscoverySession.devices
    }
}

