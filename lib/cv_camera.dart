import 'cv_camera.dart';
import 'cv_camera_platform_interface.dart';
import 'src/models/object_detection_options.dart';

export 'src/controller/camera_controller.dart';
export 'src/misc/camera_shoot_effect.dart';
export 'src/misc/pitch/camera_pitch.dart';
export 'src/models/models.dart';
export 'src/preview/camera_preview.dart';
export 'src/utils/image_builder.dart';

abstract class CvCamera {
  static CameraController getCameraController({
    LensDirection? lensDirection,
    bool? enableDistortionCorrection,
    ObjectDetectionOptions? objectDetectionOptions,
  }) =>
      CvCameraPlatform.instance.getCameraController(
        lensDirection: lensDirection,
        enableDistortionCorrection: enableDistortionCorrection,
        objectDetectionOptions: objectDetectionOptions,
      );
}
