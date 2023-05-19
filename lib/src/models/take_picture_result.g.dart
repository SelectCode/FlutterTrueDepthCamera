// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'take_picture_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_TakePictureResult _$$_TakePictureResultFromJson(Map<String, dynamic> json) =>
    _$_TakePictureResult(
      faceIdSensorData: json['depthData'] == null
          ? null
          : FaceIdSensorData.fromJson(
              json['depthData'] as Map<String, dynamic>),
      cameraImage: CameraImage.fromJson(json['image'] as Map<String, dynamic>),
      path: json['path'] as String?,
    );

Map<String, dynamic> _$$_TakePictureResultToJson(
        _$_TakePictureResult instance) =>
    <String, dynamic>{
      'depthData': instance.faceIdSensorData,
      'image': instance.cameraImage,
      'path': instance.path,
    };
