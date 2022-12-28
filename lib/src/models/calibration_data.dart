import 'dart:typed_data';

import 'package:cv_camera/src/utils/converters/float64_list_converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'calibration_data.freezed.dart';

part 'calibration_data.g.dart';

@freezed
class CGPoint with _$CGPoint {
  const factory CGPoint({
    required double x,
    required double y,
  }) = _CGPoint;

  factory CGPoint.fromJson(Map<String, dynamic> json) =>
      _$CGPointFromJson(json);
}

@freezed
class CGSize with _$CGSize {
  const factory CGSize({
    required double width,
    required double height,
  }) = _CGSize;

  factory CGSize.fromJson(Map<String, dynamic> json) => _$CGSizeFromJson(json);
}

@freezed
class CGVector with _$CGVector {
  const factory CGVector({
    required double x,
    required double y,
    required double z,
  }) = _CGVector;

  factory CGVector.fromJson(Map<String, dynamic> json) =>
      _$CGVectorFromJson(json);
}

@freezed
class CvCameraCalibrationData with _$CvCameraCalibrationData {
  factory CvCameraCalibrationData.fromJson(Map<String, dynamic> json) {
    return CvCameraCalibrationData(
      pixelSize: json['pixelSize'],
      intrinsicMatrix: (json['intrinsicMatrix'] as List)
          .map((e) => CGVector.fromJson(Map<String, dynamic>.of(e)))
          .toList(),
      extrinsicMatrix: (json['extrinsicMatrix'] as List)
          .map((e) => CGVector.fromJson(Map<String, dynamic>.of(e)))
          .toList(),
      intrinsicMatrixReferenceDimensions: CGSize.fromJson(
          Map<String, dynamic>.of(json['intrinsicMatrixReferenceDimensions'])),
      lensDistortionLookupTable: const Float64ListConverter()
          .fromJson(json['lensDistortionLookupTable'] as List),
      lensDistortionCenter: CGPoint.fromJson(
        Map<String, dynamic>.of(
          json['lensDistortionCenter'],
        ),
      ),
    );
  }

  const factory CvCameraCalibrationData({
    required double pixelSize,
    required List<CGVector> intrinsicMatrix,
    required List<CGVector> extrinsicMatrix,
    required CGSize intrinsicMatrixReferenceDimensions,
    @Float64ListConverter() required Float64List lensDistortionLookupTable,
    required CGPoint lensDistortionCenter,
  }) = _CvCameraCalibrationData;
}
