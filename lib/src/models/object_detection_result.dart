import 'package:freezed_annotation/freezed_annotation.dart';

part 'object_detection_result.freezed.dart';

part 'object_detection_result.g.dart';

@freezed
class ObjectDetectionResult with _$ObjectDetectionResult {
  const factory ObjectDetectionResult({
    required int belowLowerBound,
    required int aboveUpperBound,
    required int leftOfBound,
    required int rightOfBound,
    required int aboveBound,
    required int belowBound,
    required int insideBound,
    required int boundPointCount,
  }) = _ObjectDetectionResult;

  factory ObjectDetectionResult.fromJson(Map<String, dynamic> json) =>
      _$ObjectDetectionResultFromJson(json);
}
