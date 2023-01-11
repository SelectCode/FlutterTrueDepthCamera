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

    init(methodChannel: FlutterMethodChannel, eventChannel: FlutterEventChannel) {
        self.methodChannel = methodChannel
        self.eventChannel = eventChannel
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
                arguments: args as! [String: Any]?,
                methodChannel: methodChannel, eventChannel: eventChannel
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
    private let imageStreamHandler: ImageStreamHandler!

    @available(iOS 11.1, *)
    init(
            frame: CGRect,
            viewIdentifier viewId: Int64,
            arguments args: [String: Any]?,
            methodChannel: FlutterMethodChannel,
            eventChannel: FlutterEventChannel
    ) {
        _view = UIView()
        self.eventChannel = eventChannel
        self.methodChannel = methodChannel
        imageStreamHandler = ImageStreamHandler()
        var lensDirection: LensDirection;
        switch (args!["lensDirection"] as! String) {
        case "front": lensDirection = .front
        case "back": lensDirection = .back
        default:
            print("no lens direction was provided, defaulting to front")
            lensDirection = .front
        }
        scannerController = ScannerController(lensDirection: lensDirection)
        super.init()

        self.createNativeView(view: self.view())

        self.eventChannel.setStreamHandler(self.imageStreamHandler)
        self.methodChannel.setMethodCallHandler({
            (call, result) in
            switch (call.method) {
            case "startImageStream":
                self.startImageStream()
                result("")
            case "stopImageStream":
                self.stopImageStream()
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
            default:
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

    private func notifyAboutInitDone() {
        self.methodChannel.invokeMethod("initDone", arguments: nil)
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

    func calibrationDataSnapshot(_ onData: @escaping ((Dictionary<String, Any?>) -> Void)) {
        scannerController?.getCalibrationData { (data) in
            let calibrationData = data
            let pixelSize = NSNumber(value: calibrationData.pixelSize)
            let iMatrix = calibrationData.intrinsicMatrix.columns;
            let intrinsicMatrix = [
                self.parseMatrixCol(iMatrix.0),
                self.parseMatrixCol(iMatrix.1),
                self.parseMatrixCol(iMatrix.2),
            ]
            let eMatrix = calibrationData.extrinsicMatrix.columns
            let extrinsicMatrix: [Dictionary<String, NSNumber>] = [
                self.parseMatrixCol(eMatrix.0),
                self.parseMatrixCol(eMatrix.1),
                self.parseMatrixCol(eMatrix.2),
                self.parseMatrixCol(eMatrix.3),
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

            onData([
                "intrinsicMatrix": intrinsicMatrix,
                "intrinsicMatrixReferenceDimensions": intrinsicMatrixReferenceDimensions,
                "extrinsicMatrix": extrinsicMatrix,
                "pixelSize": pixelSize,
                "lensDistortionLookupTable": lensDistortionLookupTable,
                "lensDistortionCenter": lensDistortionCenter
            ]);
        }
    }

    func parseMatrixCol(_ col: simd_float3) -> Dictionary<String, NSNumber> {
        return [
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

                onData(FlutterStandardTypedData(float32: Data(data.flatMap {$0.bytes})))
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

        return [
            "width": width,
            "height": height,
            "xyz": xyz,
            "rgb": rgb,
            "depthValues": depthValues
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
