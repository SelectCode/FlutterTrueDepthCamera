import 'package:cv_camera/cv_camera.dart';
import 'package:cv_camera/src/models/object_detection_options.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'cv_camera_method_channel.dart';

abstract class CvCameraPlatform extends PlatformInterface {
  /// Constructs a CvCameraPlatform.
  CvCameraPlatform() : super(token: _token);

  static final Object _token = Object();

  static CvCameraPlatform _instance = MethodChannelCvCamera();

  /// The default instance of [CvCameraPlatform] to use.
  ///
  /// Defaults to [MethodChannelCvCamera].
  static CvCameraPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [CvCameraPlatform] when
  /// they register themselves.
  static set instance(CvCameraPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  CameraController getCameraController({
    LensDirection? lensDirection,
    bool? enableDistortionCorrection,
    ObjectDetectionOptions? objectDetectionOptions,
    PreferredResolution? preferredResolution,
    PreferredFrameRate? preferredFrameRate,
    bool? useDepthCamera,
  });
}
