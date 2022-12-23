import 'package:cv_camera/cv_camera.dart';
import 'package:cv_camera/cv_camera_method_channel.dart';
import 'package:flutter_test/flutter_test.dart';

import 'shared/json_resources.dart';
import 'utils/camera_mock_method_call_handler.dart';
import 'utils/set_up_camera_controller.dart';

abstract class ImageStreamResources {
  static final jsonImages = [
    JsonResources.nativeCameraImageJson,
    JsonResources.nativeCameraImageJson,
    JsonResources.nativeCameraImageJson,
  ];

  static final serializedImages = [
    JsonResources.nativeCameraImageSerialized,
    JsonResources.nativeCameraImageSerialized,
    JsonResources.nativeCameraImageSerialized,
  ];
}

main() {
  group('start image stream test', () {
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

    void emitImage(Map<String, dynamic> image) {
      platform.eventChannel.binaryMessenger.handlePlatformMessage(
          'cv_camera/events',
          platform.eventChannel.codec
              .encodeSuccessEnvelope(image),
          (data) {});
    }

    test('should invoke startImageStream platform method', () async {
      await sut.startImageStream();
      expect(tracker.calls[0].method, 'startImageStream');
    });

    test('should set isStreaming to true', () async {
      await sut.startImageStream();
      expect(sut.isStreaming, true);
    });

    test('should only invoke startImageStream method', () async {
      await sut.startImageStream();
      expect(tracker.calls.length, 1);
    });

    test('should not pass any arguments', () async {
      await sut.startImageStream();
      expect(tracker.calls[0].arguments, null);
    });

    test('invoking startImageStream again should throw exception',
        () async {
      await sut.startImageStream();
      expect(() => sut.startImageStream(), throwsException );
    });

    test(
        'should return stream of camera images when an image stream is running',
        () async {
      final stream = await sut.startImageStream();
      expect(stream, isA<Stream<CameraImage>>());
    });

    test('returned stream should contain images that are sent from platform',
        () async {
      final stream = await sut.startImageStream();
      expectLater(stream, emitsInOrder(ImageStreamResources.serializedImages));
      for (var image in ImageStreamResources.jsonImages) {
        emitImage(image);
      }
    });
  });
}
