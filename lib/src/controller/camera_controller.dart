import 'package:flutter/material.dart';

import '../models/models.dart';

abstract class CameraController {
  /// Starts a stream of [CameraImage].
  Future<Stream<CameraImage>> startImageStream();

  /// Stops the current image stream.
  ///
  /// Does nothing when the image stream is not running.
  Future<void> stopImageStream();

  /// Takes a picture.
  ///
  /// Returns a [TakePictureResult].
  ///
  /// [FaceIdSensorData] is null when device does not have a face id sensor or [lensDirection] is not [LensDirection.front].
  Future<TakePictureResult> takePicture();

  /// Disposes all needed resources of the [CameraController].
  ///
  /// [CameraController] cannot be used after.
  ///
  /// Stops the current image stream.
  Future<void> dispose();

  /// Is `true` when controller is initialized and ready to be operated on.
  bool get initialized;

  /// Is `true` when an image stream is running.
  bool get isStreaming;

  /// The size of the current camera preview.
  Size get previewSize;

  /// Determines which lens the camera uses.
  LensDirection get lensDirection;
}
