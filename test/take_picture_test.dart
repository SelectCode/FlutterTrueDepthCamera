import 'dart:io';
import 'dart:typed_data';

import 'package:clock/clock.dart';
import 'package:cv_camera/cv_camera_method_channel.dart';
import 'package:cv_camera/src/controller/camera_controller.dart';
import 'package:cv_camera/src/models/models.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import 'shared/json_resources.dart';
import 'utils/camera_mock_method_call_handler.dart';
import 'utils/set_up_camera_controller.dart';

abstract class TakePictureTestResources {
  static const depthDataJson = {
    "width": 200,
    "height": 200,
    "rgb": [1],
    "xyz": [1.0],
    "depthValues": [1.0],
  };

  static final depthDataSerialized = FaceIdSensorData(
    rgb: Uint8List.fromList([1]),
    xyz: Float64List.fromList([1.0]),
    width: 200,
    height: 200,
    depthValues: Float32List.fromList([1.0]),
  );

  static const takePictureResultJson = {
    "image": JsonResources.nativeCameraImageJson,
    "depthData": depthDataJson
  };

  static const tempDirPath = "test/resources/temp";

  static final takePictureResult = TakePictureResult(
    faceIdSensorData: depthDataSerialized,
    cameraImage: JsonResources.nativeCameraImageSerialized,
    path: '-',
  );
}

class MockPathProviderPlatform extends PathProviderPlatform {
  @override
  Future<String?> getTemporaryPath() async {
    return TakePictureTestResources.tempDirPath;
  }
}

void main() {
  group('take picture', () {
    late CameraController sut;

    late MethodChannel methodChannel;

    late MethodChannelCvCamera platform;

    late Clock mockClock;

    void mockPathProvider() {
      PathProviderPlatform.instance = MockPathProviderPlatform();
    }

    late Map<String, dynamic> takePictureResult;

    void setMockMethodCallHandler() {
      setCameraMockMethodCallHandler(methodChannel, (call) async {
        if (call.method == 'takePicture') {
          return takePictureResult;
        }
      });
    }

    String getExpectedPath() {
      return "${TakePictureTestResources.tempDirPath}/${mockClock.now().millisecondsSinceEpoch}.jpg";
    }

    Future<void> setUpSut({LensDirection? lensDirection}) async {
      mockClock = Clock.fixed(DateTime.now());
      mockPathProvider();
      setMockMethodCallHandler();
      sut = await setUpCameraController(
        lensDirection: lensDirection,
        mockClock: mockClock,
        platform: platform,
      );
    }

    setUp(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      takePictureResult = TakePictureTestResources.takePictureResultJson;
      platform = MethodChannelCvCamera();
      methodChannel = platform.methodChannel;
      await setUpSut();
    });

    test('should return serialized correct camera image', () async {
      final result = await sut.takePicture();
      expect(result.cameraImage, JsonResources.nativeCameraImageSerialized);
    });

    test('should return serialized correct depth data', () async {
      final result = await sut.takePicture();
      expect(
        result.faceIdSensorData,
        TakePictureTestResources.depthDataSerialized,
      );
    });

    test('should return correct path', () async {
      final result = await sut.takePicture();
      final expectedPath = getExpectedPath();
      expect(result.path, expectedPath);
    });

    test('should not return face id sensor data when depth data is null',
        () async {
      final resultWithNull = {...takePictureResult};
      resultWithNull['depthData'] = null;
      takePictureResult = resultWithNull;
      await setUpSut(lensDirection: LensDirection.back);
      final result = await sut.takePicture();
      expect(result.faceIdSensorData, isNull);
    });

    test('should save image to specified path', () async {
      final path = getExpectedPath();
      await sut.takePicture();
      final file = File(path);
      expect(file.existsSync(), isTrue);
    });
  });
}
