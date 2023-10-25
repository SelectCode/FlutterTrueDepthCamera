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
    final list = object.toList();
    // replace all nan values with -0
    for (var i = 0; i < list.length; i++) {
      if (list[i].isNaN || list[i].isInfinite) {
        list[i] = 0.0;
      }
    }
    return list;
  }
}
