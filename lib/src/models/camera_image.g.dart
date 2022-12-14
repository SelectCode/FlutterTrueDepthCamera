// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'camera_image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_CameraImage _$$_CameraImageFromJson(Map<String, dynamic> json) =>
    _$_CameraImage(
      width: json['width'] as int,
      height: json['height'] as int,
      planes: (json['planes'] as List<dynamic>)
          .map((e) => Plane.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$_CameraImageToJson(_$_CameraImage instance) =>
    <String, dynamic>{
      'width': instance.width,
      'height': instance.height,
      'planes': instance.planes,
    };
