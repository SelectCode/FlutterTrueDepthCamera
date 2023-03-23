import 'cv_camera.dart';
import 'cv_camera_platform_interface.dart';

export 'src/controller/camera_controller.dart';
export 'src/misc/camera_shoot_effect.dart';
export 'src/models/models.dart';
export 'src/preview/camera_preview.dart';

abstract class CvCamera {
  static CameraController getCameraController(
          {LensDirection? lensDirection, bool? enableDistortionCorrection}) =>
      CvCameraPlatform.instance.getCameraController(
        lensDirection: lensDirection,
        enableDistortionCorrection: enableDistortionCorrection,
      );
}
