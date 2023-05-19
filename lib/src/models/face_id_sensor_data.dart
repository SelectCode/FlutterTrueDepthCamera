import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:cv_camera/cv_camera.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
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
  /// Create a new instance of CameraIntrinsics with given parameters
  const factory CameraIntrinsics({
    required double intrinsicsFx,
    required double intrinsicsFy,
    required double intrinsicsCx,
    required double intrinsicsCy,
  }) = _CameraIntrinsics;

  /// Create a new instance of CameraIntrinsics from a JSON object
  factory CameraIntrinsics.fromJson(Map<String, dynamic> json) =>
      _$CameraIntrinsicsFromJson(json);

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
    required int width,
    required int height,
    required Uint8List bytes,
  }) = _DepthImage;
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

  DepthImage toDepthImage({double? discardAbove, double? discardBelow}) {
    double maxDepth = double.negativeInfinity;
    double minDepth = double.infinity;

    // Find min and max depth values within valid range
    for (int i = 0; i < depthValues.length; i++) {
      double z = depthValues[i];
      if ((discardBelow == null || z >= discardBelow) &&
          (discardAbove == null || z <= discardAbove)) {
        maxDepth = math.max(maxDepth, z);
        minDepth = math.min(minDepth, z);
      }
    }

    // Normalize depthValues between 0 and 255
    final normalizedDepthValues = Uint8List(depthValues.length);
    for (int i = 0; i < depthValues.length; i++) {
      double z = depthValues[i];
      if (z >= minDepth && z <= maxDepth) {
        // Convert z value to 0-255 grayscale value
        normalizedDepthValues[i] =
            ((z - minDepth) / (maxDepth - minDepth) * 255).round();
      }
    }

    return DepthImage(
      maxDepth: maxDepth,
      minDepth: minDepth,
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
