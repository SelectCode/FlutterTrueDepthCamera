import 'dart:io';
import 'dart:typed_data';

import 'package:clock/clock.dart';
import 'package:cv_camera/cv_camera_method_channel.dart';
import 'package:cv_camera/src/controller/camera_controller.dart';
import 'package:cv_camera/src/controller/camera_controller_impl.dart';
import 'package:cv_camera/src/models/models.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CameraController', () {
    late CameraController sut;
    MethodChannelCvCamera platform = MethodChannelCvCamera();
    late Clock mockClock;
    const methodChannelName = "com.icontrol.carprofiler/nativeCamera";
    const eventChannelName =
        "com.icontrol.carprofiler/nativeCamera/imageStream";
    final fixedTime = DateTime.now();
    setUpAll(() {
      TestWidgetsFlutterBinding.ensureInitialized();
    });
    void setUpController() {
      mockClock = Clock.fixed(fixedTime);
      sut = CameraControllerImpl(
        eventChannel: platform.eventChannel,
        methodChannel: platform.methodChannel,
        clock: mockClock,
      );
    }

    Future<void> mockNativeMethodCall(String method, dynamic data) async {
      await ServicesBinding.instance?.defaultBinaryMessenger
          .handlePlatformMessage(
              methodChannelName,
              const StandardMethodCodec()
                  .encodeMethodCall(MethodCall(method, data)),
              (ByteData? data) {});
    }

    final nativeCameraImage = CameraImage(width: 200, height: 200, planes: [
      Plane(
        width: 200,
        height: 200,
        bytes: Uint8List.fromList([1]),
        bytesPerRow: 2,
      )
    ]);
    final nativeCameraImageJson = {
      "height": 200,
      "width": 200,
      "planes": [
        {
          "height": 200,
          "width": 200,
          "bytes": [1],
          "bytesPerRow": 2
        }
      ]
    };

    final depthData = FaceIdSensorData(
        rgb: Uint8List.fromList([1]),
        xyz: Float64List.fromList([1.0]),
        width: 200,
        height: 200);
    final depthDataJson = {
      "width": 200,
      "height": 200,
      "rgb": [1],
      "xyz": [1.0]
    };

    setUp(setUpController);

    Map<String, int> countCalls() {
      final calls = <String, int>{};
      platform.methodChannel.setMockMethodCallHandler((call) {
        calls[call.method] =
            calls[call.method] == null ? 1 : calls[call.method]! + 1;
        return Future.value();
      });

      return calls;
    }

    group('startImageStream', () {
      setUp(setUpController);

      // test("should start an image stream", () async {
      //   final images = [nativeCameraImage, nativeCameraImage];
      //   mockImageStream([nativeCameraImageJson, nativeCameraImageJson]);
      //   expect(await sut.startImageStream(), emitsInOrder(images));
      // });
      //
      // test('should set isStreaming to true', () async {
      //   mockImageStream([]);
      //   await sut.startImageStream();
      //   expect(sut.isStreaming, true);
      // });
    });

    group('stopImageStream', () {
      setUp(() {
        setUpController();
      });

      test("should stop the current image stream", () async {
        final calls = countCalls();
        await sut.startImageStream();
        await sut.stopImageStream();
        expect(calls["startImageStream"], 1);
        expect(calls["stopImageStream"], 1);
      });

      test('should set isStreaming to false', () async {
        await sut.stopImageStream();
        expect(sut.isStreaming, false);
      });

      test('should do nothing when there is no stream running', () async {
        final calls = countCalls();
        await sut.stopImageStream();
        expect(calls["stopImageStream"], 0);
      });
    });

    final takePictureResultJson = {
      "image": nativeCameraImageJson,
      "depthData": depthDataJson
    };
    const temporaryDirectoryPath = 'test-temp';
    final takePictureResult = TakePictureResult(
      faceIdSensorData: depthData,
      cameraImage: nativeCameraImage,
      path: '$temporaryDirectoryPath${fixedTime.millisecondsSinceEpoch}.jpg',
    );

    group('lensDirection', () {
      setUp(setUpController);
      test(
          "controller should have the lens direction that was passed in the constructor",
          () {
        const lensDirection = LensDirection.back;
        expect(
          platform
              .getCameraController(lensDirection: lensDirection)
              .lensDirection,
          equals(lensDirection),
        );
      });
      test("lensDirection should default to front", () {
        expect(platform.getCameraController().lensDirection,
            equals(LensDirection.front));
      });
    });

    group('ready', () {
      const previewSize = Size(200, 200);

      final previewSizeJson = {
        "width": previewSize.width,
        "height": previewSize.height,
      };
      setUp(() {
        setUpController();
        platform.methodChannel.setMockMethodCallHandler((call) async {
          if (call.method == "getPreviewSize") {
            return previewSizeJson;
          }
          return null;
        });
      });
      test("should complete readyCompleter", () async {
        final controller = sut as CameraControllerImpl;
        expect(controller.readyCompleter.isCompleted, false);
        await sut.ready();
        expect(controller.readyCompleter.isCompleted, true);
      });

      test('should initialize all needed properties', () async {
        final calls = countCalls();
        await sut.ready();
        expect(sut.previewSize, previewSize);
        expect(calls["getPreviewSize"], 1);
      });

      test('should set initialized to true', () async {
        expect(sut.initialized, isFalse);
        await sut.ready();
        expect(sut.initialized, isTrue);
      });

      test('should only be callable once', () async {
        await sut.ready();
        await sut.ready();
      });
    });

    group('takePicture', () {
      setUp(setUpController);
      test("should get current image from native platform", () async {
        final calls = countCalls();
        platform.methodChannel.setMockMethodCallHandler((call) async {
          if (call.method == "takePicture") {
            return takePictureResultJson;
          }
          return null;
        });
        final result = await sut.takePicture();
        expect(File(result.path).existsSync(), true);
        expect(result, equals(takePictureResult));
        expect(calls["takePicture"], 1);
      });
    });

    group('dispose', () {
      setUp(() {
        setUpController();
      });

      test('should stop current image stream', () async {
        final calls = countCalls();
        await sut.startImageStream();
        await sut.dispose();
        expect(calls["stopImageStream"], 1);
      });

      test('should call dispose', () async {
        final calls = countCalls();
        await sut.dispose();
        expect(calls["dispose"], 1);
      });
    });
  });
}
