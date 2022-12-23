import 'package:cv_camera/cv_camera.dart';
import 'package:cv_camera/cv_camera_method_channel.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils/camera_mock_method_call_handler.dart';
import 'utils/set_up_camera_controller.dart';

void main() {
  group('dispose test', () {
    late MethodChannelCvCamera platform;

    late MethodCallTracker tracker;

    late CameraController sut;

    void setMethodChannelHandler() {
      tracker =
          setCameraMockMethodCallHandler(platform.methodChannel, (call) async {
        if (call.method == 'dispose') {
          return Future.value();
        }
      });
    }

    setUp(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      platform = MethodChannelCvCamera();
      setMethodChannelHandler();
      sut = await setUpCameraController(
        platform: platform,
      );
    });

    test('should invoke dispose platform method', () async {
      await sut.dispose();
      expect(tracker.calls[0].method, 'dispose');
    });

    test('should only invoke dispose method', () async {
      await sut.dispose();
      expect(tracker.calls.length, 1);
    });

    test('should not pass any arguments', () async {
      await sut.dispose();
      expect(tracker.calls[0].arguments, null);
    });


    test('should invoke stopImageStream when an image stream is running', () async {
      await sut.startImageStream();
      await sut.dispose();
      expect(tracker.calls[1].method, 'stopImageStream');
    });
  });
}
