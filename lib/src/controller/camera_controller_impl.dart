import 'dart:async';
import 'dart:io';

import 'package:clock/clock.dart';
import 'package:cv_camera/src/misc/pitch/pitch.dart';
import 'package:cv_camera/src/models/object_detection_options.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../../cv_camera.dart';

class CameraControllerImpl implements CameraController {
  @visibleForTesting
  late final MethodChannel methodChannel;
  final EventChannel eventChannel;
  final EventChannel objectDetectionEventChannel;

  LensDirection _lensDirection;

  @override
  final ObjectDetectionOptions objectDetectionOptions;

  @override
  final bool enableDistortionCorrection;

  /// Determines which lens the camera uses.
  @override
  LensDirection get lensDirection => _lensDirection;
  @visibleForTesting
  final Clock clock;

  /// The size of the current camera preview.
  ///
  /// Throws an exception when [initialized] is false.
  @override
  late Size previewSize;

  CameraControllerImpl({
    LensDirection? lensDirection,
    required this.eventChannel,
    required this.methodChannel,
    required this.objectDetectionEventChannel,
    ObjectDetectionOptions? objectDetectionOptions,
    this.enableDistortionCorrection = true,
    Clock? clock,
  })  : _lensDirection = lensDirection ?? LensDirection.front,
        clock = clock ?? const Clock(),
        objectDetectionOptions = objectDetectionOptions ??
            const ObjectDetectionOptions(
              minDepth: 0.15,
              maxDepth: 0.5,
              centerWidthStart: 0.3,
              centerWidthEnd: 0.7,
              centerHeightStart: 0.3,
              centerHeightEnd: 0.7,
              minCoverage: 0.5,
            ) {
    methodChannel.setMethodCallHandler((call) async {
      switch (call.method) {
        case "initDone":
          await onInitDone();
      }
    });
  }

  @visibleForTesting

  /// Initialize all properties that are sent from the ios platform
  Future<void> init() async {
    final sizeResponse = Map<String, dynamic>.from(
        (await methodChannel.invokeMethod("previewSize")));

    final width = sizeResponse["width"] as num;
    final height = sizeResponse["height"] as num;
    previewSize = Size(width.toDouble(), height.toDouble());
    _pitchService.startListening();
  }

  bool _isStreaming = false;

  /// Is `true` when the image stream is currently running.
  @override
  bool get isStreaming => _isStreaming;

  @visibleForTesting
  set isStreaming(bool isStreaming) => _isStreaming = isStreaming;

  @override
  Future<Stream<CameraImage>> startImageStream() async {
    await readyCompleter.future;

    if (isStreaming) {
      throw Exception("Image stream is already running.");
    }

    await methodChannel.invokeMethod("startImageStream");
    _isStreaming = true;
    return eventChannel.receiveBroadcastStream().map((event) {
      final json = Map<String, dynamic>.from(event);
      final decoded = CameraImage.fromJson(json);
      return decoded;
    });
  }

  @override
  Future<void> stopImageStream() async {
    await readyCompleter.future;
    if (!isStreaming) return;

    await methodChannel.invokeMethod("stopImageStream");
    _isStreaming = false;
  }

  /// Responsible for saving a [CameraImage] to the the file system.
  ///
  /// Is `static` because it needs to be run in an isolate.
  static Future<TakePictureResult> _savePictureHandler(
      PictureHandlerParams params) async {
    final response = params.response;
    final temporaryDirPath = params.temporaryDirectoryPath;
    final clock = params.clock;

    final cameraImage =
        CameraImage.fromJson(Map<String, dynamic>.from(response['image']));
    final imageFile = File(
      join(
        temporaryDirPath,
        '${clock.now().millisecondsSinceEpoch}.jpg',
      ),
    );
    await imageFile.create(recursive: true);
    final imageBuilder =
        ImageBuilder.fromCameraImage(cameraImage).rotate(90).flipHorizontally();
    final bytes = imageBuilder.asJpg();
    final writtenFile = (await imageFile.writeAsBytes(bytes));
    final path = writtenFile.path;
    print(response['depthData'].runtimeType);
    final decoded =
        TakePictureResult.fromJson(response..addAll({'path': path}));

    return decoded;
  }

  @override
  Future<TakePictureResult> takePicture({bool saveImage = false}) async {
    await readyCompleter.future;
    final data = await methodChannel.invokeMethod("takePicture");
    final response = Map<String, dynamic>.from(data)
      ..addAll({'pitch': (await _getCurrentPitch()).toJson()});
    if (!saveImage) {
      final result = TakePictureResult.fromJson(response);
      return result;
    }
    return await compute<PictureHandlerParams, TakePictureResult>(
      _savePictureHandler,
      PictureHandlerParams(
        response: response,
        temporaryDirectoryPath: (await getTemporaryDirectory()).path,
        clock: clock,
      ),
    );
  }

  final PitchService _pitchService = PitchService();

  Future<CameraPitch> _getCurrentPitch() async {
    return await _pitchService.getPitch();
  }

  /// Is `true` when controller is initialized and ready to be operated on.
  @override
  bool get initialized => readyCompleter.isCompleted;

  @visibleForTesting
  final Completer readyCompleter = Completer();

  @visibleForTesting
  Future<void> onInitDone() async {
    if (initialized) return;
    await init();
    readyCompleter.complete();
  }

  @override
  Future<void> dispose() async {
    await stopImageStream();
    await methodChannel.invokeMethod('dispose');
    _pitchService.stopListening();
  }

  @override
  Future<CvCameraCalibrationData> getCalibrationData() async {
    final response = Map<String, dynamic>.from(
      await methodChannel.invokeMethod("get_calibration_data"),
    );
    return CvCameraCalibrationData.fromJson(response);
  }

  @override
  Future<FaceIdSensorData> getFaceIdSensorData() async {
    final response = Map<String, dynamic>.from(
      await methodChannel.invokeMethod("get_face_id_sensor_data"),
    );
    return FaceIdSensorData.fromJson(response);
  }

  @override
  Future<List<double>> getDepthValues() async {
    final result =
        await methodChannel.invokeMethod<Float32List>("get_depth_values");
    return result!.toList();
  }

  bool _isDetecting = false;

  @override
  Future<Stream<double>> startObjectCoverageStream() async {
    await readyCompleter.future;

    if (_isDetecting) {
      throw Exception("Object stream is already running.");
    }

    await methodChannel.invokeMethod("startObjectDetection");
    _isDetecting = true;
    return objectDetectionEventChannel.receiveBroadcastStream().map((event) {
      return event as double;
    });
  }

  @override
  Future<void> stopObjectCoverageStream() async {
    await readyCompleter.future;
    if (!_isDetecting) return;

    await methodChannel.invokeMethod("stopObjectDetection");
    _isDetecting = false;
  }

  @override
  Future<void> setLensDirection(LensDirection lensDirection) async {
    await readyCompleter.future;
    await methodChannel.invokeMethod("change_lens_direction", {
      "lensDirection": lensDirection.value,
    });
    _lensDirection = lensDirection;
  }
}

/// Params that are passed to [CameraControllerImpl._savePictureHandler].
class PictureHandlerParams {
  final Map<String, dynamic> response;
  final String temporaryDirectoryPath;
  final Clock clock;

  const PictureHandlerParams({
    required this.response,
    required this.temporaryDirectoryPath,
    required this.clock,
  });
}
