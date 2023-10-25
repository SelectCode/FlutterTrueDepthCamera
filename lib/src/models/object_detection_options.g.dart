// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'object_detection_options.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ObjectDetectionOptions _$$_ObjectDetectionOptionsFromJson(
        Map<String, dynamic> json) =>
    _$_ObjectDetectionOptions(
      minDepth: (json['minDepth'] as num).toDouble(),
      maxDepth: (json['maxDepth'] as num).toDouble(),
      centerWidthStart: (json['centerWidthStart'] as num).toDouble(),
      centerWidthEnd: (json['centerWidthEnd'] as num).toDouble(),
      centerHeightStart: (json['centerHeightStart'] as num).toDouble(),
      centerHeightEnd: (json['centerHeightEnd'] as num).toDouble(),
      minCoverage: (json['minCoverage'] as num).toDouble(),
    );

Map<String, dynamic> _$$_ObjectDetectionOptionsToJson(
        _$_ObjectDetectionOptions instance) =>
    <String, dynamic>{
      'minDepth': instance.minDepth,
      'maxDepth': instance.maxDepth,
      'centerWidthStart': instance.centerWidthStart,
      'centerWidthEnd': instance.centerWidthEnd,
      'centerHeightStart': instance.centerHeightStart,
      'centerHeightEnd': instance.centerHeightEnd,
      'minCoverage': instance.minCoverage,
    };
