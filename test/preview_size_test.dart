import 'package:cv_camera/cv_camera.dart';
import 'package:cv_camera/cv_camera_method_channel.dart';
import 'package:flutter_test/flutter_test.dart';

import 'shared/test_resources.dart';
import 'utils/camera_mock_method_call_handler.dart';
import 'utils/set_up_camera_controller.dart';

main() {
  group('preview size test', () {
    late CameraController sut;

    late MethodCallTracker tracker;

    setUp(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      final platform = MethodChannelCvCamera();
      tracker = setCameraMockMethodCallHandler(
        platform.methodChannel,
        (call) async {},
        countInit: true,
      );
      sut = await setUpCameraController(platform: platform);
    });

    test('preview size', () {
      expect(sut.previewSize, isNotNull);
    });

    test(
      'preview size should be decoded correctly',
      () {
        expect(sut.previewSize, TestResources.initialPreviewSize);
      },
    );

    test('should invoke previewSize', () {
      expect(
        tracker.calls[0].method,
        'previewSize',
      );
    });
  });
}
