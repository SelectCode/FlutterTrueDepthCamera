import 'package:clock/clock.dart';
import 'package:cv_camera/src/controller/camera_controller.dart';
import 'package:cv_camera/src/models/lens_direction.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'cv_camera_platform_interface.dart';
import 'src/controller/camera_controller_impl.dart';

/// An implementation of [CvCameraPlatform] that uses method channels.
class MethodChannelCvCamera extends CvCameraPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('cv_camera');

  @visibleForTesting
  final eventChannel = const EventChannel('cv_camera/events');

  @override
  CameraController getCameraController({
    LensDirection? lensDirection,
    Clock? clock,
  }) {
    return CameraControllerImpl(
      lensDirection: lensDirection,
      methodChannel: methodChannel,
      eventChannel: eventChannel,
      clock: clock,
    );
  }
}
