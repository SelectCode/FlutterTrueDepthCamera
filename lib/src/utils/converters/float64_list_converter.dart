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
