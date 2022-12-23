import 'package:cv_camera/cv_camera.dart';
import 'package:cv_camera/cv_camera_method_channel.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils/camera_mock_method_call_handler.dart';
import 'utils/set_up_camera_controller.dart';

main() {
  group('stop image stream test', ()  {
    late CameraController sut;

    late MethodCallTracker tracker;

    late MethodChannelCvCamera platform;

    setUp(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      platform = MethodChannelCvCamera();
      tracker =
          setCameraMockMethodCallHandler(platform.methodChannel, (call) async {
        if (call.method == 'startImageStream') {
          return Future.value();
        }
      });
      sut = await setUpCameraController(platform: platform);
    });

    test('should invoke stopImageStream', () async {
      await sut.startImageStream();
      await sut.stopImageStream();
      expect(tracker.calls[1].method, 'stopImageStream');
    });

    test('should do nothing when image stream is not running', () async {
      await sut.stopImageStream();
      expect(tracker.calls.length, 0);
    });

    test('should do nothing if image stream is stopped twice', () async {
      await sut.startImageStream();
      await sut.stopImageStream();
      await sut.stopImageStream();
      expect(tracker.calls.length, 2);
    });
  });
}
