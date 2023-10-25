import 'package:cv_camera/cv_camera.dart';
import 'package:cv_camera/cv_camera_method_channel.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils/camera_mock_method_call_handler.dart';
import 'utils/set_up_camera_controller.dart';

main() {
  group('set lens direction test', () {
    late CameraController sut;

    late MethodCallTracker tracker;

    setUp(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      final platform = MethodChannelCvCamera();
      tracker = setCameraMockMethodCallHandler(
        platform.methodChannel,
        (call) async {},
      );
      sut = await setUpCameraController(platform: platform);
    });

    test('should call change_lens_direction with correct lens direction',
        () async {
      await sut.setLensDirection(LensDirection.front);
      expect(
        tracker.calls[0].method,
        'change_lens_direction',
      );
      expect(
        tracker.calls[0].arguments,
        {
          "lensDirection": "front",
        },
      );
    });

    test('should call change_lens_direction with correct lens direction',
        () async {
      await sut.setLensDirection(LensDirection.back);
      expect(
        tracker.calls[0].method,
        'change_lens_direction',
      );
      expect(
        tracker.calls[0].arguments,
        {
          "lensDirection": "back",
        },
      );
    });

    test('lens direction getter should return correct value', () async {
      await sut.setLensDirection(LensDirection.front);
      expect(sut.lensDirection, LensDirection.front);
    });

    test('lens direction getter should return correct value', () async {
      await sut.setLensDirection(LensDirection.back);
      expect(sut.lensDirection, LensDirection.back);
    });
  });
}
