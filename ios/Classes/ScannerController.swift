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


class ScannerController: NSObject, AVCaptureDataOutputSynchronizerDelegate, AVCaptureVideoDataOutputSampleBufferDelegate {
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
    private var videoDeviceDiscoverySession: AVCaptureDevice.DiscoverySession!
    public var canUseDepthCamera: Bool!

    @available(iOS 11.1, *)
    init(lensDirection: LensDirection) {

        super.init();
        self.setDeviceDiscoverySession(lensDirection: lensDirection)

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
        var position: AVCaptureDevice.Position
        var deviceTypes: [AVCaptureDevice.DeviceType]
        // Determine which lensDirection should be used and set the [deviceTypes] accordingly.
        switch (lensDirection) {
        case .front: position = .front
            if #available(iOS 11.1, *) {
                deviceTypes = [.builtInTrueDepthCamera]
            } else {
                print("iOS 11.1 or higher is required for front camera")
                deviceTypes = [.builtInWideAngleCamera]
            }
            canUseDepthCamera = true
        case .back: position = .back
            canUseDepthCamera = true
            // only use lidar when ios version is greater or equal to 15.4

            if #available(iOS 15.4, *) {
                deviceTypes = [.builtInLiDARDepthCamera, .builtInDualCamera]
            } else {
                print("iOS 15.4 or higher is required for usage of LiDAR")
                deviceTypes = [.builtInDualCamera, .builtInWideAngleCamera]
            }

        }
        videoDeviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: deviceTypes,
                mediaType: .video,
                position: position);
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
    private var onObjectDetectedChanged: ((Bool) -> Void)?
    private var lastDetected: Bool = false


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

    func setOnObjectDetectedChangedListener(_ callback: @escaping (Bool) -> Void) {
        onObjectDetectedChanged = callback
    }

    func removeOnObjectDetectedChangedListener() {
        onObjectDetectedChanged = nil
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
            self.previewLayer?.removeFromSuperlayer()
            self.session.stopRunning()

            self.previewLayer = nil
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



            if (self.onObjectDetectedChanged != nil) {
                self.objectDetectionQueue.async {
                    let width = CVPixelBufferGetWidth(videoPixelBuffer)
                    let height = CVPixelBufferGetHeight(videoPixelBuffer)
                    let hasDetected = self.checkForObject(depthValues: depthValues, width: width, height: height)
                    if (self.lastDetected != hasDetected) {
                        self.onObjectDetectedChanged!(hasDetected)
                        self.lastDetected = hasDetected
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

    func checkForObject(depthValues: [Float32], width: Int, height: Int) -> Bool {
        let centerWidthRange = Int(Double(width) * 0.3)...Int(Double(width) * 0.7)
        let centerHeightRange = Int(Double(height) * 0.3)...Int(Double(height) * 0.7)
        let centerCount = (centerWidthRange.upperBound - centerWidthRange.lowerBound) * (centerHeightRange.upperBound - centerHeightRange.lowerBound)
        let depthRange = 0.15...0.3
        var xsCount = 0

        for (i, value) in depthValues.enumerated() {
            let x = i % width
            let y = i / width
            if depthRange.contains(Double(value)) && centerWidthRange.contains(x) && centerHeightRange.contains(y) {
                xsCount += 1
            }
        }

        let coverage = Double(xsCount) / Double(centerCount)

        let minCoverage = coverage > 0.5

        return minCoverage
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

        // Undistort depth data using lensDistortionPointForPoint
        var maybePixelBuffer: CVPixelBuffer? = nil
        let format = CVPixelBufferGetPixelFormatType(depthPixelBuffer)
//        assert(format == kCVPixelFormatType_420YpCbCr8Planar)
        let status = CVPixelBufferCreate(nil, depthWidth, depthHeight, format, nil, &maybePixelBuffer)
        guard status == kCVReturnSuccess, let undistortedBuffer = maybePixelBuffer else {
            return
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
                if(destinationOffset >= bytesPerRow * height) {
                    //todo: handle this
                    continue
                }
                if(destinationOffset != offset) {
                    changedPixelCount += 1
                }
                let destinationPointer = destination!.advanced(by: destinationOffset).assumingMemoryBound(to: UInt8.self)
                destinationPointer.pointee = sourcePointer.pointee
            }
        }
        print("Changed \(changedPixelCount) pixels out of \(depthWidth * depthHeight) pixels after undistortion.")

        CVPixelBufferUnlockBaseAddress(depthPixelBuffer, .readOnly)
        CVPixelBufferUnlockBaseAddress(undistortedBuffer, CVPixelBufferLockFlags(rawValue: 0))


        let depthValues: [Float32]? = undistortedBuffer.depthValues()
        guard let depthValues = depthValues else {
            return
        }

        guard let cameraCalibrationData = depthData.cameraCalibrationData else {
            return
        }


        let faceIdData = convertRGBDtoXYZ(colorImage: cgColorImage, depthValues: depthValues, depthWidth: depthWidth, cameraCalibrationData: cameraCalibrationData)
        print("Converted RGBD to XYZ.")
        if (copiedFaceIdSensorDataCallback != nil) {
            copiedFaceIdSensorDataCallback!(faceIdData)
        }
        if (copiedSnapshotCallback != nil) {
            copiedSnapshotCallback!(faceIdData, decodeNativeCameraImage(getNativeCameraImage(sampleBuffer: sampleBuffer)))
        }
        print("Finished processing frame.")

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

    func convertRGBDtoXYZ(colorImage: CGImage, depthValues: [Float32], depthWidth: Int, cameraCalibrationData: AVCameraCalibrationData) -> FaceIdData {

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

        return FaceIdData(XYZ: xyz, RGB: rgb, depthValues: depthValues, width: Int32(colorImage.width), height: Int32(colorImage.height))
    }


    /// Sets up current capture session.
    private func configureSession() {
        if setupResult != .success {
            return
        }

        let defaultVideoDevice: AVCaptureDevice? = videoDeviceDiscoverySession.devices.first

        guard let videoDevice = defaultVideoDevice else {
            print("Could not find any video device")
            setupResult = .configurationFailed
            return
        }

        do {
            videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
        } catch {
            print("Could not create video device input: \(error)")
            setupResult = .configurationFailed
            return
        }

        print("Using camera: \(videoDevice.localizedName) with format: \(videoDevice.activeFormat)")

        session.beginConfiguration()

        if (videoDevice.position == .front) {
            session.sessionPreset = AVCaptureSession.Preset.vga640x480
        } else {
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
}
