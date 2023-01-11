import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

class Float32ListConverter implements JsonConverter<Float32List, List> {
  const Float32ListConverter();

  @override
  Float32List fromJson(List json) {
    return Float32List.fromList(json.cast<double>());
  }

  @override
  List<double> toJson(Float32List object) {
    return object.toList();
  }
}
