import 'dart:async';
import 'dart:io';

import 'package:clock/clock.dart';
import 'package:cv_camera/src/controller/camera_controller.dart';
import 'package:cv_camera/src/misc/range.dart';
import 'package:cv_camera/src/models/calibration_data/calibration_data.dart';
import 'package:cv_camera/src/utils/image_builder.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../models/models.dart';

class CameraControllerImpl implements CameraController {
  @visibleForTesting
  late final MethodChannel methodChannel;
  final EventChannel eventChannel;

  /// Determines which lens the camera uses.
  @override
  late final LensDirection lensDirection;
  @visibleForTesting
  late final Clock clock;

  /// The size of the current camera preview.
  ///
  /// Throws an exception when [initialized] is false.
  @override
  late Size previewSize;

  CameraControllerImpl({
    LensDirection? lensDirection,
    required this.eventChannel,
    required this.methodChannel,
    Clock? clock,
  }) {
    this.clock = clock ?? const Clock();
    this.lensDirection = lensDirection ?? LensDirection.front;
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

    final decoded =
        TakePictureResult.fromJson(response..addAll({'path': path}));

    return decoded;
  }

  @override
  Future<TakePictureResult> takePicture() async {
    await readyCompleter.future;
    final response = Map<String, dynamic>.from(
        await methodChannel.invokeMethod("takePicture"));
    return await compute<PictureHandlerParams, TakePictureResult>(
      _savePictureHandler,
      PictureHandlerParams(
        response: response,
        temporaryDirectoryPath: (await getTemporaryDirectory()).path,
        clock: clock,
      ),
    );
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
    methodChannel.invokeMethod('dispose');
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
  Stream<FaceIdSensorData> getFaceIdSensorDataStream(int interval) {
    return Stream.periodic(Duration(milliseconds: interval), (i) async {
      return await getFaceIdSensorData();
    }).asyncMap((event) => event);
  }

  @override
  bool checkForObject({
    required List<double> depthValues,
    required double minCoverage,
  }) {
    if (minCoverage < 0 || minCoverage > 1) {
      throw RangeError("minCoverage must be between 0 and 1");
    }
    // todo: read values from swift
    final width = 640;
    final height = 480;

    final centerWidthRange = Range(
      (width * 0.3).toInt(),
      (width * 0.7).toInt(),
    );
    final centerHeightRange = Range(
      (height * 0.3).toInt(),
      (height * 0.7).toInt(),
    );
    final centerCount =
        (centerWidthRange.upperBound - centerWidthRange.lowerBound) *
            (centerHeightRange.upperBound - centerHeightRange.lowerBound);
    const depthRange = Range(0.15, 0.3);
    int matchingValues = 0;

    for (int i = 0; i < depthValues.length; i++) {
      final x = i % width;
      final y = i / width;
      final value = depthValues[i];
      if (depthRange.contains(value) &&
          centerWidthRange.contains(x.toInt()) &&
          centerHeightRange.contains(y.toInt())) {
        matchingValues++;
      }
    }

    final coverage = matchingValues / centerCount;
    return coverage > minCoverage;
  }

  @override
  Stream<List<double>> getDepthValueStream(int interval) {
    return Stream.periodic(Duration(milliseconds: interval), (i) async {
      // improve performance here. takes about 260 ms
      final data = await getDepthValues();
      return data;
    }).asyncMap((event) => event);
  }

  @override
  Future<List<double>> getDepthValues() async {
    final result =
        await methodChannel.invokeMethod<Float32List>("get_depth_values");
    return result!.toList();
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
