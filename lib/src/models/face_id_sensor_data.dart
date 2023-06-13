import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:collection/collection.dart';
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
  factory CameraIntrinsics.fromCalibrationData(
    CvCameraCalibrationData data, {
    required double imageWidth,
    required double imageHeight,
  }) {
    final intrinsicMatrix = data.intrinsicMatrix;
    final referenceDimensions = data.intrinsicMatrixReferenceDimensions;
    final ratioWidth = imageWidth / referenceDimensions.width;
    final ratioHeight = imageHeight / referenceDimensions.height;
    print('ratioWidth: $ratioWidth');
    print('ratioHeight: $ratioHeight');
    return CameraIntrinsics(
      intrinsicsFx: intrinsicMatrix[0].x * ratioWidth,
      intrinsicsFy: intrinsicMatrix[1].y * ratioHeight,
      intrinsicsCx: intrinsicMatrix[2].x * ratioWidth,
      intrinsicsCy: intrinsicMatrix[2].y * ratioHeight,
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

  /// Converts facial information into a 3D depth image.
  ///
  /// This method works by taking data that represents facial points in a 3-dimensional space (x, y, and z values)
  /// and converting it into a 2D image that visually represents the depth of each point. This can be useful for
  /// tasks such as facial recognition or detection in photos and videos.
  ///
  /// - [discardAbove] and [discardBelow] are boundaries which determine which depth values to consider.
  /// If a depth value is higher than [discardAbove] or lower than [discardBelow], we ignore it.
  /// If these parameters are not specified, all depth values are taken into account.
  ///
  /// Here's how it works:
  ///
  /// - First, the method finds the highest and lowest depth values (z values) within the specified range.
  ///
  /// - Next, it turns the depth values into shades of gray, where 0 is black and 255 is white.
  /// Points closer to the camera (lower depth values) are represented as black, and points farther away
  /// from the camera (higher depth values) are represented as white.
  ///
  /// - The formula for turning depth values into grayscale values is ((z - minDepth) / (maxDepth - minDepth) * 255).
  ///
  /// - Finally, the method returns a DepthImage, which includes the grayscale values that represent the depths,
  /// the image's width and height, and the highest and lowest depth values.
  ///
  /// Note: This method expects that the data in xyz is structured in a way where every set of 3 values represents
  /// the x, y, and z coordinates of a point on the face. The order of these sets corresponds to the image's width and height.
  ///
  /// Example:
  ///
  /// Let's say we have a set of points representing a face in a 3D space: (1,1,1), (2,2,2), and (3,3,3).
  /// We want to convert this into a 2D depth image. We'll call this method with our data:
  ///
  /// /// FaceIdSensorData data = new FaceIdSensorData(xyz: [1,1,1,2,2,2,3,3,3]); /// DepthImage depthImage = data.toDepthImage(); ///
  ///
  /// In this example, the blackest point in the resulting image will represent the point (1,1,1),
  /// as it's the closest to the camera. The whitest point will represent (3,3,3),
  /// as it's the farthest. The point (2,2,2) will be a shade of gray.
  ///
  /// The resulting DepthImage can be used to visualize the depth of the face in a 2D space,
  /// which can be helpful for computer vision tasks like facial recognition or detection.
  DepthImage toDepthImage() {
    double maxDepth = double.negativeInfinity;
    double minDepth = double.infinity;
    double maxX = double.negativeInfinity;
    double minX = double.infinity;
    double maxY = double.negativeInfinity;
    double minY = double.infinity;

    List<double> zValues = List<double>.filled(xyz.length ~/ 3, 0);

    // One pass to gather z values and find min and max for x, y, z
    for (int i = 0; i < xyz.length; i += 3) {
      double z = xyz[i + 2];
      double x = xyz[i];
      double y = xyz[i + 1];
      zValues.add(z);
      maxX = math.max(maxX, x);
      minX = math.min(minX, x);
      maxY = math.max(maxY, y);
      minY = math.min(minY, y);
      maxDepth = math.max(maxDepth, z);
      minDepth = math.min(minDepth, z);
    }

    // Calculate the quartiles
    zValues.sort();
    double Q1 = zValues[(zValues.length * 0.25).round()];
    double Q3 = zValues[(zValues.length * 0.75).round()];

    // Calculate the interquartile range
    double IQR = Q3 - Q1;

    // Define the discard values based on the IQR
    double discardBelow = Q1 - 1.5 * IQR;
    double discardAbove = Q3 + 1.5 * IQR;

    // Filter outliers from min and max depths
    minDepth = math.max(minDepth, discardBelow);
    maxDepth = math.min(maxDepth, discardAbove);

    // Normalize depth (z) values between 0 and 255
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

  double _quickselect(List<double> list, int n) {
    // Note: This function will modify the original list
    int from = 0;
    int to = list.length - 1;

    while (from < to) {
      int r = from, w = to;
      double mid = list[(r + w) >> 1];

      while (r < w) {
        if (list[r] >= mid) {
          double t = list[w];
          list[w] = list[r];
          list[r] = t;
          --w;
        } else {
          ++r;
        }
      }

      if (list[r] > mid) {
        --r;
      }

      if (n <= r) {
        to = r;
      } else {
        from = r + 1;
      }
    }

    return list[n];
  }

  List<(double, double, double)> getXYZNoIntrinsics() {
    return depthValues.mapIndexed((offset, z) {
      final x = offset % width;
      final y = offset ~/ width;
      return (x.toDouble(), y.toDouble(), z);
    }).toList();
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
