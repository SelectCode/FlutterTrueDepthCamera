import 'package:freezed_annotation/freezed_annotation.dart';

part 'cg_size.freezed.dart';
part 'cg_size.g.dart';

@freezed
class CGSize with _$CGSize {
  const factory CGSize({
    required double width,
    required double height,
  }) = _CGSize;

  factory CGSize.fromJson(Map<String, dynamic> json) => _$CGSizeFromJson(json);
}
