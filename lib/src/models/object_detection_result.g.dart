// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'object_detection_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ObjectDetectionResult _$$_ObjectDetectionResultFromJson(
        Map<String, dynamic> json) =>
    _$_ObjectDetectionResult(
      belowLowerBound: json['belowLowerBound'] as int,
      aboveUpperBound: json['aboveUpperBound'] as int,
      leftOfBound: json['leftOfBound'] as int,
      rightOfBound: json['rightOfBound'] as int,
      aboveBound: json['aboveBound'] as int,
      belowBound: json['belowBound'] as int,
      insideBound: json['insideBound'] as int,
      boundPointCount: json['boundPointCount'] as int,
    );

Map<String, dynamic> _$$_ObjectDetectionResultToJson(
        _$_ObjectDetectionResult instance) =>
    <String, dynamic>{
      'belowLowerBound': instance.belowLowerBound,
      'aboveUpperBound': instance.aboveUpperBound,
      'leftOfBound': instance.leftOfBound,
      'rightOfBound': instance.rightOfBound,
      'aboveBound': instance.aboveBound,
      'belowBound': instance.belowBound,
      'insideBound': instance.insideBound,
      'boundPointCount': instance.boundPointCount,
    };
