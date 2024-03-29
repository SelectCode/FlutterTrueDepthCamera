import 'package:clock/clock.dart';
import 'package:cv_camera/src/controller/camera_controller.dart';
import 'package:cv_camera/src/models/lens_direction.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'cv_camera.dart';
import 'cv_camera_platform_interface.dart';
import 'src/controller/camera_controller_impl.dart';

/// An implementation of [CvCameraPlatform] that uses method channels.
class MethodChannelCvCamera extends CvCameraPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('cv_camera');

  @visibleForTesting
  final eventChannel = const EventChannel('cv_camera/events');

  final objectDetectionEventChannel =
      const EventChannel('cv_camera/objectDetection');

  @override
  CameraController getCameraController({
    LensDirection? lensDirection,
    bool? enableDistortionCorrection,
    ObjectDetectionOptions? objectDetectionOptions,
    PreferredResolution? preferredResolution,
    PreferredFrameRate? preferredFrameRate,
    Clock? clock,
    bool? useDepthCamera,
  }) {
    return CameraControllerImpl(
      lensDirection: lensDirection,
      methodChannel: methodChannel,
      eventChannel: eventChannel,
      objectDetectionEventChannel: objectDetectionEventChannel,
      clock: clock,
      enableDistortionCorrection: enableDistortionCorrection ?? true,
      objectDetectionOptions: objectDetectionOptions,
      preferredFrameRate: preferredFrameRate ?? PreferredFrameRate.fps30,
      preferredResolution: preferredResolution ?? PreferredResolution.x640x480,
      useDepthCamera: useDepthCamera ?? true,
    );
  }
}
