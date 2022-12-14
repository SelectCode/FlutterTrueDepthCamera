import Flutter
import UIKit

public class SwiftCvCameraPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "cv_camera", binaryMessenger: registrar.messenger())
        let eventChannel = FlutterEventChannel(name: "cv_camera/events", binaryMessenger: registrar.messenger())
        if #available(iOS 11.1, *) {
            let factory = FLNativeViewFactory(methodChannel: channel, eventChannel: eventChannel)
            registrar.register(factory, withId: "camera")
        } else {
            // Fallback on earlier versions
        }

    }
}
