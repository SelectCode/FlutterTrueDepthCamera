import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

class Float64ListConverter implements JsonConverter<Float64List, List> {
  const Float64ListConverter();

  @override
  Float64List fromJson(List json) {
    return Float64List.fromList(
      json.cast<num>().map((e) => e.toDouble()).toList(),
    );
  }

  @override
  List<double> toJson(Float64List object) {
    return object.toList();
  }
}
