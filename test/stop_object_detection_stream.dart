import 'package:cv_camera/cv_camera.dart';
import 'package:cv_camera/cv_camera_method_channel.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils/camera_mock_method_call_handler.dart';
import 'utils/set_up_camera_controller.dart';

main() {
  group('stop object detection stream test', () {
    late CameraController sut;

    late MethodCallTracker tracker;

    late MethodChannelCvCamera platform;

    setUp(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      platform = MethodChannelCvCamera();
      tracker =
          setCameraMockMethodCallHandler(platform.methodChannel, (call) async {
        if (call.method == 'startObjectDetection') {
          return Future.value();
        }
      });
      sut = await setUpCameraController(platform: platform);
    });

    test('should invoke stopObjectDetection', () async {
      await sut.startObjectCoverageStream();
      await sut.stopObjectCoverageStream();
      expect(tracker.calls[1].method, 'stopObjectDetection');
    });

    test('should do nothing when ObjectDetection stream is not running',
        () async {
      await sut.stopObjectCoverageStream();
      expect(tracker.calls.length, 0);
    });

    test('should do nothing if stream is stopped twice', () async {
      await sut.startObjectCoverageStream();
      await sut.stopObjectCoverageStream();
      await sut.stopObjectCoverageStream();
      expect(tracker.calls.length, 2);
    });
  });
}
