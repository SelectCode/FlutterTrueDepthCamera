import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../utils/converters/uint8_list_converter.dart';

part 'plane.freezed.dart';
part 'plane.g.dart';

@freezed
class Plane with _$Plane {
  const factory Plane({
    required int width,
    required int height,
    @Uint8ListConverter() required Uint8List bytes,
    required int bytesPerRow,
  }) = _Plane;

  factory Plane.fromJson(Map<String, dynamic> json) => _$PlaneFromJson(json);

  @override
  Map<String, dynamic> toJson() => throw UnimplementedError();
}
