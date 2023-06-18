import 'package:freezed_annotation/freezed_annotation.dart';

part 'object_detection_options.freezed.dart';

part 'object_detection_options.g.dart';

@freezed
class ObjectDetectionOptions with _$ObjectDetectionOptions {
  const factory ObjectDetectionOptions({
    required double minDepth,
    required double maxDepth,
    required double centerWidthStart,
    required double centerWidthEnd,
    required double centerHeightStart,
    required double centerHeightEnd,
    required double minCoverage,
  }) = _ObjectDetectionOptions;

  factory ObjectDetectionOptions.fromJson(Map<String, dynamic> json) =>
      _$ObjectDetectionOptionsFromJson(json);
}
