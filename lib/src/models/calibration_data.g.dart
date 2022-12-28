// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calibration_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_CGPoint _$$_CGPointFromJson(Map<String, dynamic> json) => _$_CGPoint(
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
    );

Map<String, dynamic> _$$_CGPointToJson(_$_CGPoint instance) =>
    <String, dynamic>{
      'x': instance.x,
      'y': instance.y,
    };

_$_CGSize _$$_CGSizeFromJson(Map<String, dynamic> json) => _$_CGSize(
      width: (json['width'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
    );

Map<String, dynamic> _$$_CGSizeToJson(_$_CGSize instance) => <String, dynamic>{
      'width': instance.width,
      'height': instance.height,
    };

_$_CGVector _$$_CGVectorFromJson(Map<String, dynamic> json) => _$_CGVector(
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      z: (json['z'] as num).toDouble(),
    );

Map<String, dynamic> _$$_CGVectorToJson(_$_CGVector instance) =>
    <String, dynamic>{
      'x': instance.x,
      'y': instance.y,
      'z': instance.z,
    };

_$_CvCameraCalibrationData _$$_CvCameraCalibrationDataFromJson(
        Map<String, dynamic> json) =>
    _$_CvCameraCalibrationData(
      pixelSize: (json['pixelSize'] as num).toDouble(),
      intrinsicMatrix: (json['intrinsicMatrix'] as List<dynamic>)
          .map((e) => CGVector.fromJson(e as Map<String, dynamic>))
          .toList(),
      extrinsicMatrix: (json['extrinsicMatrix'] as List<dynamic>)
          .map((e) => CGVector.fromJson(e as Map<String, dynamic>))
          .toList(),
      intrinsicMatrixReferenceDimensions: CGSize.fromJson(
          json['intrinsicMatrixReferenceDimensions'] as Map<String, dynamic>),
      lensDistortionLookupTable: const Float64ListConverter()
          .fromJson(json['lensDistortionLookupTable'] as List),
      lensDistortionCenter: CGPoint.fromJson(
          json['lensDistortionCenter'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_CvCameraCalibrationDataToJson(
        _$_CvCameraCalibrationData instance) =>
    <String, dynamic>{
      'pixelSize': instance.pixelSize,
      'intrinsicMatrix': instance.intrinsicMatrix,
      'extrinsicMatrix': instance.extrinsicMatrix,
      'intrinsicMatrixReferenceDimensions':
          instance.intrinsicMatrixReferenceDimensions,
      'lensDistortionLookupTable': const Float64ListConverter()
          .toJson(instance.lensDistortionLookupTable),
      'lensDistortionCenter': instance.lensDistortionCenter,
    };
