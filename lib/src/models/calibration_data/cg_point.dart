import 'package:freezed_annotation/freezed_annotation.dart';

part 'cg_point.freezed.dart';

part 'cg_point.g.dart';

@freezed
class CGPoint with _$CGPoint {
  const factory CGPoint({
    required double x,
    required double y,
  }) = _CGPoint;

  factory CGPoint.fromJson(Map<String, dynamic> json) =>
      _$CGPointFromJson(json);
}
