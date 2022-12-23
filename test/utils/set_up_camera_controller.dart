import 'package:clock/clock.dart';
import 'package:cv_camera/cv_camera.dart';
import 'package:cv_camera/cv_camera_method_channel.dart';
import 'package:cv_camera/src/controller/camera_controller_impl.dart';

Future<CameraController> setUpCameraController({
  required MethodChannelCvCamera platform,
  LensDirection? lensDirection,
  Clock? mockClock,
}) async {
  final cameraController = platform.getCameraController(
    lensDirection: lensDirection,
    clock: mockClock,
  );
  await (cameraController as CameraControllerImpl).onInitDone();
  return cameraController;
}
