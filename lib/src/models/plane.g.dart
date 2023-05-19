// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plane.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Plane _$$_PlaneFromJson(Map<String, dynamic> json) => _$_Plane(
      width: json['width'] as int,
      height: json['height'] as int,
      bytes: const Uint8ListConverter().fromJson(json['bytes'] as List),
      bytesPerRow: json['bytesPerRow'] as int,
    );

Map<String, dynamic> _$$_PlaneToJson(_$_Plane instance) => <String, dynamic>{
      'width': instance.width,
      'height': instance.height,
      'bytes': const Uint8ListConverter().toJson(instance.bytes),
      'bytesPerRow': instance.bytesPerRow,
    };
