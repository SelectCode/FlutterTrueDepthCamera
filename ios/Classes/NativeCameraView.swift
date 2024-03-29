//
//  NativeCameraView.swift
//  Runner
//
//  Created by Julian Hartl on 04.04.22.
//

import Foundation
import Flutter
import UIKit

@available(iOS 11.1, *)
class FLNativeViewFactory: NSObject, FlutterPlatformViewFactory {
    private var methodChannel: FlutterMethodChannel
    private var eventChannel: FlutterEventChannel
    private var objectChangedEventChannel: FlutterEventChannel

    init(methodChannel: FlutterMethodChannel, eventChannel: FlutterEventChannel, objectChangedEventChannel: FlutterEventChannel) {
        self.methodChannel = methodChannel
        self.eventChannel = eventChannel
        self.objectChangedEventChannel = objectChangedEventChannel
        super.init()
    }

    func create(
            withFrame frame: CGRect,
            viewIdentifier viewId: Int64,
            arguments args: Any?
    ) -> FlutterPlatformView {
        FLNativeView(
                frame: frame,
                viewIdentifier: viewId,
                arguments: args as! [String: Any],
                methodChannel: methodChannel, eventChannel: eventChannel, objectChangedEventChannel: objectChangedEventChannel
        )
    }

    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        FlutterStandardMessageCodec.sharedInstance()
    }


}

class FLNativeView: NSObject, FlutterPlatformView {
    private var _view: UIView
    private var previewView: UIView!
    private let button = UIButton()
    private var scannerController: ScannerController?
    private var methodChannel: FlutterMethodChannel!
    private var eventChannel: FlutterEventChannel!
    private var objectChangedEventChannel: FlutterEventChannel!
    private let imageStreamHandler: ImageStreamHandler!
    private let onObjectDetectedChangedStreamHandler: ObjectDetectedChangedHandler!

    @available(iOS 11.1, *)
    init(
            frame: CGRect,
            viewIdentifier viewId: Int64,
            arguments args: [String: Any],
            methodChannel: FlutterMethodChannel,
            eventChannel: FlutterEventChannel,
            objectChangedEventChannel: FlutterEventChannel
    ) {
        _view = UIView()
        self.eventChannel = eventChannel
        self.methodChannel = methodChannel
        self.objectChangedEventChannel = objectChangedEventChannel
        imageStreamHandler = ImageStreamHandler()
        let cameraOptions = FLNativeView.parseCameraOptions(args: args)
        scannerController = ScannerController(cameraOptions: cameraOptions)
        onObjectDetectedChangedStreamHandler = ObjectDetectedChangedHandler(scannerController: scannerController!)
        super.init()

        createNativeView(view: view())

        self.eventChannel.setStreamHandler(self.imageStreamHandler)
        self.objectChangedEventChannel.setStreamHandler(self.onObjectDetectedChangedStreamHandler)
        self.methodChannel.setMethodCallHandler({
            (call, result) in
            do {
                switch (call.method) {
                case "startImageStream":
                    self.startImageStream()
                    result("")
                case "stopImageStream":
                    self.stopImageStream()
                    result("")
                case "startObjectDetection":
                    self.startObjectDetectedChangedStream()
                    result("")
                case "stopObjectDetection":
                    self.stopObjectDetectedChangedStream()
                    result("")
                case "previewSize":
                    result(self.getPreviewSize())
                case "takePicture":
                    self.snapshot({
                        data in
                        result(data)
                    })
                case "get_face_id_sensor_data":
                    self.faceIdSensorDataSnapshot({
                        data in
                        result(data)
                    })
                case "get_calibration_data":
                    self.calibrationDataSnapshot({
                        data in
                        result(data)
                    })
                case "get_depth_values":
                    self.depthValuesSnapshot({
                        data in
                        result(data)
                    })
                case "dispose":
                    self.dispose {
                        result(nil);
                    }
                case "change_lens_direction":
                    let lensDirection = FLNativeView.parseLensDirection(args: call.arguments as? [String: Any])
                    self.scannerController!.changeLensDirection(lensDirection)
                    result("")
                case "start_movie_recording":
                    self.scannerController!.startMovieRecording()
                    result(nil)
                case "stop_movie_recording":
                    self.scannerController!.stopMovieRecording { url, error in
                        if let error = error {
                            result(FlutterError(code: "\(error._code)", message: error.localizedDescription, details: nil))
                            return
                        }
                        result(url.absoluteURL.absoluteString)
                    }
                default:
                    result(FlutterError())
                }
            } catch {
                result(FlutterError())
            }


        })

        scannerController?.prepare { (error) in
            if let error = error {
                print(error)
            }
            if (self.disposed) {
                return;
            }
            // iOS views can be created here
            try? self.scannerController?.displayPreview(on: self.previewView)
            self.notifyAboutInitDone()

        }


    }

    private static func parseLensDirection(args: [String: Any]?) -> LensDirection {
        var lensDirection: LensDirection;
        switch (args!["lensDirection"] as! String) {
        case "front": lensDirection = .front
        case "back": lensDirection = .back
        default:
            print("no lens direction was provided, defaulting to front")
            lensDirection = .front
        }
        return lensDirection;
    }

    private static func parseObjectDetectionRange(args: [String: Any]) -> ObjectDetectionOptions {
        let options: [String: Any] = args["objectDetectionOptions"] as! [String: Any];
        let minDepth: Double = Double(truncating: options["minDepth"] as! NSNumber)
        let maxDepth: Double = Double(truncating: options["maxDepth"] as! NSNumber)
        let centerWidthStart: Double = Double(truncating: options["centerWidthStart"] as! NSNumber)
        let centerWidthEnd: Double = Double(truncating: options["centerWidthEnd"] as! NSNumber)
        let centerHeightStart: Double = Double(truncating: options["centerHeightStart"] as! NSNumber)
        let centerHeightEnd: Double = Double(truncating: options["centerHeightEnd"] as! NSNumber)
        let minCoverage: Double = Double(truncating: options["minCoverage"] as! NSNumber)
        return ObjectDetectionOptions(
                minDepth: minDepth,
                maxDepth: maxDepth,
                centerWidthStart: centerWidthStart,
                centerWidthEnd: centerWidthEnd,
                centerHeightStart: centerHeightStart,
                centerHeightEnd: centerHeightEnd,
                minCoverage: minCoverage
        )
    }

    private static func parseCameraOptions(args: [String: Any]) -> CameraOptions {
        let lensDirection: LensDirection = FLNativeView.parseLensDirection(args: args)
        let enableDistortionCorrection: Bool = args["enableDistortionCorrection"] as! Bool
        let objectDetectionRange = FLNativeView.parseObjectDetectionRange(args: args)
        let preferredResolution: PreferredResolution!
        let rawRes = args["preferredResolution"] as! String
        switch rawRes {
        case "x1920x1080":
            preferredResolution = PreferredResolution.x1920x1080
        case "x640x480":
            preferredResolution = PreferredResolution.x640x480
        default:
            print("Encountered unknown resolution: \(rawRes)")
            preferredResolution = PreferredResolution.x640x480
        }
        let rawFrameRate = args["preferredFrameRate"] as! String
        let preferredFrameRate: PreferredFrameRate!

        switch rawFrameRate {
        case "fps24":
            preferredFrameRate = PreferredFrameRate.fps24
        case "fps30":
            preferredFrameRate = PreferredFrameRate.fps30
        case "fps60":
            preferredFrameRate = PreferredFrameRate.fps60
        case "fps120":
            preferredFrameRate = PreferredFrameRate.fps120
        case "fps240":
            preferredFrameRate = PreferredFrameRate.fps240
        default:
            print("Encountered unknown frame rate: \(rawFrameRate)")
            preferredFrameRate = PreferredFrameRate.fps30
        }
        return CameraOptions(
                lensDirection: lensDirection,
                enableDistortionCorrection: enableDistortionCorrection,
                useDepthCamera: args["useDepthCamera"] as! Bool,
                objectDetectionOptions: objectDetectionRange,
                preferredFrameRate: preferredFrameRate,
                preferredResolution: preferredResolution
        )
    }

    private func notifyAboutInitDone() {
        methodChannel.invokeMethod("initDone", arguments: nil)
    }


    func view() -> UIView {
        _view
    }

    func createNativeView(view _view: UIView) {
        _view.backgroundColor = UIColor.black
        previewView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        previewView.contentMode = UIView.ContentMode.topLeft
        previewView.sizeToFit()
        _view.addSubview(previewView)
    }

    func getPreviewSize() -> Dictionary<String, Any?> {
        [
            "width": NSNumber(value: previewView.layer.frame.width),
            "height": NSNumber(value: previewView.layer.frame.height)
        ]
    }

    func calibrationDataSnapshot(_ onData: @escaping (Dictionary<String, Any?>) -> Void) {
        scannerController?.getCalibrationData { (data) in
            let encodedData = self.encodeCameraCalibrationData(data: data)
            onData(encodedData);
        }
    }

    private func encodeCameraCalibrationData(data: AVCameraCalibrationData) -> [String: Any] {
        let calibrationData = data
        let pixelSize = NSNumber(value: calibrationData.pixelSize)
        let iMatrix = calibrationData.intrinsicMatrix.columns;
        let intrinsicMatrix = [
            parseMatrixCol(iMatrix.0),
            parseMatrixCol(iMatrix.1),
            parseMatrixCol(iMatrix.2),
        ]
        let eMatrix = calibrationData.extrinsicMatrix.columns
        let extrinsicMatrix: [Dictionary<String, NSNumber>] = [
            parseMatrixCol(eMatrix.0),
            parseMatrixCol(eMatrix.1),
            parseMatrixCol(eMatrix.2),
            parseMatrixCol(eMatrix.3),
        ]
        let intrinsicMatrixReferenceDimensionsData = calibrationData.intrinsicMatrixReferenceDimensions
        let intrinsicMatrixReferenceDimensions: Dictionary<String, NSNumber> = [
            "width": NSNumber(value: intrinsicMatrixReferenceDimensionsData.width),
            "height": NSNumber(value: intrinsicMatrixReferenceDimensionsData.height),
        ]
        let lensDistortionCenterData = calibrationData.lensDistortionCenter
        let lensDistortionCenter: Dictionary<String, NSNumber> = [
            "x": NSNumber(value: lensDistortionCenterData.x),
            "y": NSNumber(value: lensDistortionCenterData.y),
        ]
        let lensDistortionLookupTableData = calibrationData.lensDistortionLookupTable
        let lensDistortionLookupTable = FlutterStandardTypedData(bytes: Data(lensDistortionLookupTableData!.map { point in
            point
        }))
        let inverseLensDistortionLookupTableData =
                FlutterStandardTypedData(bytes: Data(calibrationData.inverseLensDistortionLookupTable!.map { point in
                    point
                }))

        let encodedData: Dictionary<String, Any> = [
            "intrinsicMatrix": intrinsicMatrix,
            "intrinsicMatrixReferenceDimensions": intrinsicMatrixReferenceDimensions,
            "extrinsicMatrix": extrinsicMatrix,
            "pixelSize": pixelSize,
            "lensDistortionLookupTable": lensDistortionLookupTable,
            "lensDistortionCenter": lensDistortionCenter,
            "inverseLensDistortionLookupTable": inverseLensDistortionLookupTableData
        ]
        return encodedData
    }

    func parseMatrixCol(_ col: simd_float3) -> Dictionary<String, NSNumber> {
        [
            "x": NSNumber(value: col.x),
            "y": NSNumber(value: col.y),
            "z": NSNumber(value: col.z)
        ]
    }

    func faceIdSensorDataSnapshot(_ onData: @escaping (Dictionary<String, Any?>) -> Void) -> Void {
        scannerController!.getFaceIdSensorDataSnapshot { data in
            let encoded = self.encodeFaceIdSensorData(data)
            onData(encoded)
        }
    }

    func depthValuesSnapshot(_ onData: @escaping (Any) -> Void) -> Void {
        scannerController!.getDepthValuesSnapshot { data in

            onData(FlutterStandardTypedData(float32: Data(data.flatMap {
                $0.bytes
            })))
        }
    }

    func snapshot(_ onData: @escaping (Dictionary<String, Any?>) -> Void) -> Void {
        if (disposed) {
            return;
        }
        if (scannerController!.canUseDepthCamera) {
            scannerController?.getSnapshot { (data, image) in
                let encoded = self.encodeFaceIdSensorData(data)
                let pictureData: Dictionary<String, Any?> = [
                    "image": self.encodeNativeCameraImage(image: image), "depthData": encoded]
                onData(pictureData)

            }
        } else {
            scannerController?.getImageBytes({ imageData in
                let pictureData: Dictionary<String, Any?> = [
                    "image": imageData];
                onData(pictureData)
            })
        }

    }

    func startObjectDetectedChangedStream() {
        if (disposed) {
            return;
        }

        scannerController?.setOnObjectCoverageChangeListener({ (detected) in
            self.onObjectDetectedChangedStreamHandler.add(detected)
        })
    }

    func stopObjectDetectedChangedStream() {
        if (disposed) {
            return;
        }
        scannerController?.removeOnObjectCoverageChangedListener()
    }


    func startImageStream() {
        if (disposed) {
            return;
        }
        scannerController?.startStreaming({ data in self.imageStreamHandler.add(image: data) })
    }

    private func encodeFaceIdSensorData(_ data: FaceIdData) -> [String: Any] {
        let width = NSNumber(value: data.width)
        let height = NSNumber(value: data.height)
        let rgb = FlutterStandardTypedData(bytes: Data(data.RGB.flatMap { point in
            point.compactMap {
                $0
            }
        }))
        let xyz = FlutterStandardTypedData(float64: Data(data.XYZ.flatMap { point in
            point.flatMap {
                Float64($0).bytes
            }
        }))
        let depthValues = FlutterStandardTypedData(float32: Data(
                data.depthValues.flatMap {
                    $0.bytes
                }
        ))
        let calibrationData = encodeCameraCalibrationData(data: data.cameraCalibrationData)
        return [
            "width": width,
            "height": height,
            "xyz": xyz,
            "rgb": rgb,
            "depthValues": depthValues,
            "cameraCalibrationData": calibrationData
        ]
    }

    private func encodeNativeCameraImage(image: NativeCameraImage) -> [String: Any] {
        [
            "width": NSNumber(value: image.width),
            "height": NSNumber(value: image.height),
            "planes": image.planes.map({
                plane in
                [
                    "height": NSNumber(value: plane.height),
                    "width": NSNumber(value: plane.width),
                    "bytes": FlutterStandardTypedData(bytes: Data(plane.bytes)),
                    "bytesPerRow": NSNumber(value: plane.bytesPerRow)]
            })
        ]
    }

    func stopImageStream() {
        if (disposed) {
            return;
        }
        scannerController?.stopStreaming()
    }

    private var disposed: Bool = false;


    func dispose(_ callback: () -> Void) {
        if (disposed) {
            callback();
            return;
        }
        print("stopping scanner controller")
        disposed = true;
        scannerController!.stop { e in
            if (e != nil) {
                print(e)
            }
            self.scannerController = nil;
            callback()
        }

    }
}

class ObjectDetectedChangedHandler: NSObject, FlutterStreamHandler {


    private var eventSink: FlutterEventSink?

    private var scannerController: ScannerController

    init(scannerController: ScannerController) {
        self.scannerController = scannerController
    }

    func add(_ detected: ObjectDetectionResult) {
        let encoded: Dictionary<String, NSInteger> = [
            "belowLowerBound": NSInteger(detected.belowLowerBound),
            "aboveUpperBound": NSInteger(detected.aboveUpperBound),
            "leftOfBound": NSInteger(detected.leftOfBound),
            "rightOfBound": NSInteger(detected.rightOfBound),
            "aboveBound": NSInteger(detected.aboveBound),
            "belowBound": NSInteger(detected.belowBound),
            "insideBound": NSInteger(detected.insideBound),
            "boundPointCount": NSInteger(detected.boundPointCount),
        ]
        eventSink?(encoded)
    }

    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        return nil;
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        cancelListener()
        return nil;
    }

    func cancelListener() {
        scannerController.removeOnObjectCoverageChangedListener()
    }
}


class ImageStreamHandler: NSObject, FlutterStreamHandler {


    private var eventSink: FlutterEventSink?

    func add(image: [String: Any]) {
        eventSink?(image)
    }

    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        return nil;
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        nil;
    }
}
