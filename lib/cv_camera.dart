import 'package:cv_camera/src/controller/camera_controller.dart';

import 'cv_camera_platform_interface.dart';

export 'src/controller/camera_controller.dart';
export 'src/models/models.dart';
export 'src/preview/camera_preview.dart';

abstract class CvCamera {
  static CameraController getCameraController() =>
      CvCameraPlatform.instance.getCameraController();
}
