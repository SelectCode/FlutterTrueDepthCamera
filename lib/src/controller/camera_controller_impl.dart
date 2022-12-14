import 'dart:async';
import 'dart:io';

import 'package:clock/clock.dart';
import 'package:cv_camera/src/controller/camera_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart';
import 'package:isolate_handler/isolate_handler.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../models/models.dart';

class _OnTakePictureArgs {
  final StreamController<TakePictureResult> controller;
  final Map<String, dynamic> data;

  const _OnTakePictureArgs({
    required this.controller,
    required this.data,
  });
}

/// A [CameraControllerImpl] controls a [CameraPreview].
class CameraControllerImpl implements CameraController {
  @visibleForTesting
  late final MethodChannel methodChannel;
  late final StreamController<TakePictureResult> _takePictureController;
  @visibleForTesting
  final EventChannel eventChannel;
  late final IsolateHandler<_OnTakePictureArgs, void> _isolateHandler;

  /// Determines which lens the camera uses.
  @override
  late final LensDirection lensDirection;
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
    @visibleForTesting this.clock = const Clock(),
  }) {
    this.lensDirection = lensDirection ?? LensDirection.front;
    _takePictureController = StreamController();
    _isolateHandler = IsolateHandler(handler: _onTakePicture);
    methodChannel.setMethodCallHandler((call) async {
      switch (call.method) {
        case "takePicture":
          _isolateHandler.send(
            params: _OnTakePictureArgs(
              controller: _takePictureController,
              data: call.arguments,
            ),
          );
          break;
        case "initDone":
          await _onInitDone();
      }
    });
  }

  static Future<void> _onTakePicture(_OnTakePictureArgs args) async {
    final takePictureResult = TakePictureResult.fromJson(args.data);
    args.controller.add(takePictureResult);
  }

  /// Initialize all properties that are sent from the ios platform
  Future<void> _init() async {
    final sizeResponse = Map<String, dynamic>.from(
        (await methodChannel.invokeMethod("previewSize")));

    previewSize = Size(sizeResponse["width"], sizeResponse["height"]);
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
    if (!_isolateHandler.isSpawned) await _isolateHandler.spawn();

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

    final image =
        CameraImage.fromJson(Map<String, dynamic>.from(response['image']));
    final imageFile = File(
        join(temporaryDirPath, '${clock.now().millisecondsSinceEpoch}.jpg'));
    await imageFile.create(recursive: true);

    final decodedImage = decodeImage(image.getBytes().toList());
    if (decodedImage == null) {
      throw Exception("Could not decode image");
    }
    final encoded = JpegEncoder().encodeImage(decodedImage);
    final path = (await imageFile.writeAsBytes(encoded)).path;
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

  @override
  Future<void> _onInitDone() async {
    if (initialized) return;
    await _init();
    readyCompleter.complete();
  }

  @override
  Future<void> dispose() async {
    _isolateHandler.close();
    await stopImageStream();
    methodChannel.invokeMethod('dispose');
  }

  @override
  Future<void> flipCamera() {
    throw UnimplementedError();
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
