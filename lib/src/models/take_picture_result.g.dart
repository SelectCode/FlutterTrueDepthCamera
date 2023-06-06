// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'take_picture_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_TakePictureResult _$$_TakePictureResultFromJson(Map<String, dynamic> json) =>
    _$_TakePictureResult(
      faceIdSensorData: json['depthData'],
      cameraImage: json['image'],
      pitch: CameraPitch.fromJson(json['pitch'] as Map<String, dynamic>),
      path: json['path'] as String?,
    );

Map<String, dynamic> _$$_TakePictureResultToJson(
        _$_TakePictureResult instance) =>
    <String, dynamic>{
      'depthData': instance.faceIdSensorData,
      'image': instance.cameraImage,
      'pitch': instance.pitch,
      'path': instance.path,
    };
tring, dynamic>{
      'depthData': instance.faceIdSensorData,
      'image': instance.cameraImage,
      'pitch': instance.pitch,
      'path': instance.path,
    };
