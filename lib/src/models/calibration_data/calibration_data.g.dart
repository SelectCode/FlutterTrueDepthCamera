// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calibration_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_CvCameraCalibrationData _$$_CvCameraCalibrationDataFromJson(Map json) =>
    _$_CvCameraCalibrationData(
      pixelSize: (json['pixelSize'] as num).toDouble(),
      intrinsicMatrix: (json['intrinsicMatrix'] as List<dynamic>)
          .map((e) => CGVector.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      extrinsicMatrix: (json['extrinsicMatrix'] as List<dynamic>)
          .map((e) => CGVector.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      intrinsicMatrixReferenceDimensions: CGSize.fromJson(
          Map<String, dynamic>.from(
              json['intrinsicMatrixReferenceDimensions'] as Map)),
      lensDistortionLookupTable: const Float64ListConverter()
          .fromJson(json['lensDistortionLookupTable'] as List),
      lensDistortionCenter: CGPoint.fromJson(
          Map<String, dynamic>.from(json['lensDistortionCenter'] as Map)),
      inverseLensDistortionLookupTable: const Float64ListConverter()
          .fromJson(json['inverseLensDistortionLookupTable'] as List),
    );

Map<String, dynamic> _$$_CvCameraCalibrationDataToJson(
        _$_CvCameraCalibrationData instance) =>
    <String, dynamic>{
      'pixelSize': instance.pixelSize,
      'intrinsicMatrix':
          instance.intrinsicMatrix.map((e) => e.toJson()).toList(),
      'extrinsicMatrix':
          instance.extrinsicMatrix.map((e) => e.toJson()).toList(),
      'intrinsicMatrixReferenceDimensions':
          instance.intrinsicMatrixReferenceDimensions.toJson(),
      'lensDistortionLookupTable': const Float64ListConverter()
          .toJson(instance.lensDistortionLookupTable),
      'lensDistortionCenter': instance.lensDistortionCenter.toJson(),
      'inverseLensDistortionLookupTable': const Float64ListConverter()
          .toJson(instance.inverseLensDistortionLookupTable),
    };
