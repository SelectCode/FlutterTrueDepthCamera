// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'face_id_sensor_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_CameraIntrinsics _$$_CameraIntrinsicsFromJson(Map<String, dynamic> json) =>
    _$_CameraIntrinsics(
      intrinsicsFx: (json['intrinsics_fx'] as num).toDouble(),
      intrinsicsFy: (json['intrinsics_fy'] as num).toDouble(),
      intrinsicsCx: (json['intrinsics_cx'] as num).toDouble(),
      intrinsicsCy: (json['intrinsics_cy'] as num).toDouble(),
    );

Map<String, dynamic> _$$_CameraIntrinsicsToJson(_$_CameraIntrinsics instance) =>
    <String, dynamic>{
      'intrinsics_fx': instance.intrinsicsFx,
      'intrinsics_fy': instance.intrinsicsFy,
      'intrinsics_cx': instance.intrinsicsCx,
      'intrinsics_cy': instance.intrinsicsCy,
    };

_$_FaceIdSensorData _$$_FaceIdSensorDataFromJson(Map<String, dynamic> json) =>
    _$_FaceIdSensorData(
      rgb: const Uint8ListConverter().fromJson(json['rgb'] as List),
      xyz: const Float64ListConverter().fromJson(json['xyz'] as List),
      depthValues:
          const Float32ListConverter().fromJson(json['depthValues'] as List),
      width: json['width'] as int,
      height: json['height'] as int,
    );

Map<String, dynamic> _$$_FaceIdSensorDataToJson(_$_FaceIdSensorData instance) =>
    <String, dynamic>{
      'rgb': const Uint8ListConverter().toJson(instance.rgb),
      'xyz': const Float64ListConverter().toJson(instance.xyz),
      'depthValues': const Float32ListConverter().toJson(instance.depthValues),
      'width': instance.width,
      'height': instance.height,
    };
