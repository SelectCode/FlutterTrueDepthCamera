import 'package:cv_camera/cv_camera.dart';
import 'package:cv_camera/cv_camera_method_channel.dart';
import 'package:flutter_test/flutter_test.dart';

import 'shared/json_resources.dart';
import 'utils/camera_mock_method_call_handler.dart';
import 'utils/set_up_camera_controller.dart';

main() {
  group('start object detection stream test', () {
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

    void emitBoolean(bool image) {
      platform.objectDetectionEventChannel.binaryMessenger
          .handlePlatformMessage(
              'cv_camera/objectDetection',
              platform.objectDetectionEventChannel.codec
                  .encodeSuccessEnvelope(image),
              (data) {});
    }

    test('should invoke startObjectDetection platform method', () async {
      await sut.startObjectDetectionStream();
      expect(tracker.calls[0].method, 'startObjectDetection');
    });

    test('should only invoke startImageStream method', () async {
      await sut.startObjectDetectionStream();
      expect(tracker.calls.length, 1);
    });

    test('should not pass any arguments', () async {
      await sut.startObjectDetectionStream();
      expect(tracker.calls[0].arguments, null);
    });

    test('invoking startObjectDetection again should throw exception',
        () async {
      await sut.startObjectDetectionStream();
      expect(() => sut.startObjectDetectionStream(), throwsException);
    });

    test(
        'should return stream of bools when an object detection stream is running',
        () async {
      final stream = await sut.startObjectDetectionStream();
      expect(stream, isA<Stream<bool>>());
    });

    test('returned stream should contain bools that are sent from platform',
        () async {
      final stream = await sut.startObjectDetectionStream();
      final boo = [true, false, true, false, true, false, true, false, true];
      expectLater(stream, emitsInOrder(boo));
      for (var image in boo) {
        emitBoolean(image);
      }
    });
  });
}
