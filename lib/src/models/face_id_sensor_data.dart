import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:cv_camera/cv_camera.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../utils/converters/float32_list_converter.dart';
import '../utils/converters/float64_list_converter.dart';
import '../utils/converters/uint8_list_converter.dart';

part 'face_id_sensor_data.freezed.dart';

part 'face_id_sensor_data.g.dart';

/// CameraIntrinsics is a class representing the intrinsic parameters of a camera.
/// These are parameters that are inherent to the camera itself and are related to
/// the camera's build and the lens. They don't change if the scene or camera's pose changes.
///
/// `intrinsicsFx` and `intrinsicsFy` are the focal lengths of the camera lens in terms of pixels.
/// They express how strongly the camera lens converges or diverges the light onto the camera's sensor.
///
/// `intrinsicsCx` and `intrinsicsCy` are the coordinates of the principal point (usually the image center).
/// These are the pixel coordinates where the camera's optical axis intersects the image plane.
@freezed
class CameraIntrinsics with _$CameraIntrinsics {
  const factory CameraIntrinsics({
    required double intrinsicsFx,
    required double intrinsicsFy,
    required double intrinsicsCx,
    required double intrinsicsCy,
  }) = _CameraIntrinsics;

  /// Create a new instance of CameraIntrinsics from a CvCameraCalibrationData object.
  /// The intrinsic parameters are extracted from the intrinsicMatrix of the CvCameraCalibrationData object.
  factory CameraIntrinsics.fromCalibrationData(CvCameraCalibrationData data) {
    return CameraIntrinsics(
      intrinsicsFx: data.intrinsicMatrix[0].x,
      intrinsicsFy: data.intrinsicMatrix[1].y,
      intrinsicsCx: data.intrinsicMatrix[2].x,
      intrinsicsCy: data.intrinsicMatrix[2].y,
    );
  }
}

@freezed
class DepthImage with _$DepthImage {
  const factory DepthImage({
    required double maxDepth,
    required double minDepth,
    required double maxX,
    required double minX,
    required double maxY,
    required double minY,
    required int width,
    required int height,
    required Uint8List bytes,
  }) = _DepthImage;

  const DepthImage._();

  /// Converts a [DepthImage] into a grayscale image.
  ///
  /// This function converts the [DepthImage] into a grayscale image.
  /// Each pixel's red, green, and blue values are set to the corresponding grayscale value from the [DepthImage],
  /// creating a grayscale image where pixel intensity corresponds to depth.
  ///
  /// Returns a grayscale [img.Image].
  img.Image toGrayscaleImage() {
    // Create an empty image with the same dimensions as the depth image
    img.Image grayscaleImage = img.Image(
      width: width,
      height: height,
    );

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        int depth = bytes[y * width + x];
        // Setting the pixel value as grayscale
        grayscaleImage.setPixelRgb(x, y, depth, depth, depth);
      }
    }

    return grayscaleImage;
  }

  /// Converts the [DepthImage] into JPEG bytes.
  ///
  /// This function first converts the [DepthImage] into a grayscale [img.Image] using the [toGrayscaleImage]
  /// function, then encodes this image into a JPEG format.
  ///
  /// Returns a [Uint8List] containing the bytes of the JPEG image.
  Uint8List toJpegBytes() {
    img.Image grayscaleImage = toGrayscaleImage();
    Uint8List jpegBytes = img.encodeJpg(grayscaleImage);
    return jpegBytes;
  }

  /// Converts the [DepthImage] into PNG bytes.
  ///
  /// This function first converts the [DepthImage] into a grayscale [img.Image] using the [toGrayscaleImage]
  /// function, then encodes this image into a PNG format.
  ///
  /// Returns a [Uint8List] containing the bytes of the PNG image.
  Uint8List toPngBytes() {
    img.Image grayscaleImage = toGrayscaleImage();
    Uint8List pngBytes = img.encodePng(grayscaleImage);
    return pngBytes;
  }

  // Converts the [DepthImage] into a TIFF image.
  ///

  /// This function first converts the [DepthImage] into a grayscale [img.Image] using the [toGrayscaleImage]
  /// function, then encodes this image into a TIFF format.
  ///
  /// Returns a [Uint8List] containing the bytes of the TIFF image.
  Uint8List toTiffBytes() {
    img.Image grayscaleImage = toGrayscaleImage();
    Uint8List tiffBytes = img.encodeTiff(grayscaleImage);
    return tiffBytes;
  }
}

@freezed
class FaceIdSensorData with _$FaceIdSensorData {
  const factory FaceIdSensorData({
    @Uint8ListConverter() required Uint8List rgb,
    @Float64ListConverter() required Float64List xyz,
    @Float32ListConverter() required Float32List depthValues,
    required int width,
    required int height,
  }) = _FaceIdSensorData;

  const FaceIdSensorData._();

  /// Converts the FaceIdSensorData's xyz values to a DepthImage.
  ///
  /// [discardAbove] and [discardBelow] provide optional bounds to consider while calculating the depth values.
  /// Any depth value above [discardAbove] or below [discardBelow] is ignored. If these parameters are null,
  /// all depth values are considered.
  ///
  /// The method first finds the maximum and minimum depth (z) values within the valid range
  /// (determined by [discardAbove] and [discardBelow]).
  ///
  /// Then, it normalizes the depth values to grayscale values between 0 and 255.
  /// Depth values closer to the minimum depth value are assigned to black (0),
  /// and depth values closer to the maximum depth value are assigned to white (255).
  ///
  /// The normalization formula used is ((z - minDepth) / (maxDepth - minDepth) * 255).
  ///
  /// Finally, the method creates and returns a DepthImage with the grayscale values, the width and height of the image,
  /// and the maximum and minimum depth values encountered in the valid range.
  ///
  /// Note: This method assumes that the Float64List xyz is arranged in a manner consistent with
  /// the image's width and height, where every 3 elements represent the x, y and z coordinates of a point.
  DepthImage toDepthImage({double? discardAbove, double? discardBelow}) {
    double maxDepth = double.negativeInfinity;
    double minDepth = double.infinity;
    double maxX = double.negativeInfinity;
    double minX = double.infinity;
    double maxY = double.negativeInfinity;
    double minY = double.infinity;

    // Find min and max depth (z) values within valid range
    for (int i = 0; i < xyz.length; i += 3) {
      double z = xyz[i + 2]; // Z value is the third element in the xyz set
      if ((discardBelow == null || z >= discardBelow) &&
          (discardAbove == null || z <= discardAbove)) {
        maxDepth = math.max(maxDepth, z);
        minDepth = math.min(minDepth, z);
        double x = xyz[i];
        double y = xyz[i + 1];
        maxX = math.max(maxX, x);
        minX = math.min(minX, x);
        maxY = math.max(maxY, y);
        minY = math.min(minY, y);
      }
    }

    // Normalize depth (z) values between 0 and 65535
    final normalizedDepthValues =
        Uint8List(xyz.length ~/ 3); // Assuming xyz length is a multiple of 3
    for (int i = 0; i < xyz.length; i += 3) {
      double z = xyz[i + 2];
      if (z >= minDepth && z <= maxDepth) {
        // Convert z value to 0-255 grayscale value
        normalizedDepthValues[i ~/ 3] =
            ((z - minDepth) / (maxDepth - minDepth) * 255).round();
      }
    }

    return DepthImage(
      maxDepth: maxDepth,
      minDepth: minDepth,
      maxX: maxX,
      minX: minX,
      maxY: maxY,
      minY: minY,
      width: width,
      height: height,
      bytes: normalizedDepthValues,
    );
  }

  factory FaceIdSensorData.fromJson(Map<String, dynamic> json) =>
      _$FaceIdSensorDataFromJson(json);

  @override
  Map<String, dynamic> toJson() => throw UnimplementedError();
}

Future<String> writeImageFile(List<int> bytes) async {
  final directory = await getApplicationDocumentsDirectory();
  final filePath = join((directory.path), 'rgb.jpg');
  final file = File(filePath);
  file.writeAsBytes(bytes);
  return filePath;
}

Future<String> writePlyFile(FaceIdSensorData data) async {
  final points = data.xyz;

  final header =
      'ply\nformat ascii 1.0\nelement vertex ${points.length ~/ 3}\nproperty float x\nproperty float y\nproperty float z\nend_header\n';

  final directory = await getApplicationDocumentsDirectory();
  final filePath = join(directory.path, 'points.ply');

  final file = File(filePath);
  final sink = file.openWrite();

  try {
    sink.write(header);

    final buffer = StringBuffer();
    for (var i = 0; i < points.length; i += 3) {
      final point = Float64List.sublistView(points, i, i + 3);
      if (point.every((p) => p.isFinite)) {
        buffer.write('${point[0]} ${point[1]} ${point[2]}\n');
      } else {
        buffer.write('nan nan nan\n');
      }

      if (buffer.length > 1024 * 1024) {
        // print current progress + memory usage
        print('Wrote ${i ~/ 3} points');
        print('Memory usage: ${ProcessInfo.currentRss / 1024 / 1024} MB');
        sink.write(buffer.toString());
        buffer.clear();
      }
    }

    if (buffer.isNotEmpty) {
      sink.write(buffer.toString());
    }
  } finally {
    await sink.close();
  }
  print('Wrote file to $filePath');
  return filePath;
}
