import 'package:freezed_annotation/freezed_annotation.dart';

part 'cg_vector.freezed.dart';
part 'cg_vector.g.dart';

@freezed
class CGVector with _$CGVector {
  const factory CGVector({
    required double x,
    required double y,
    required double z,
  }) = _CGVector;

  factory CGVector.fromJson(Map<String, dynamic> json) =>
      _$CGVectorFromJson(json);
}
