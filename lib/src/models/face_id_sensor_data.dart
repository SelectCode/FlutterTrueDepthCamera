import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../utils/converters/float32_list_converter.dart';
import '../utils/converters/float64_list_converter.dart';
import '../utils/converters/uint8_list_converter.dart';

part 'face_id_sensor_data.freezed.dart';

part 'face_id_sensor_data.g.dart';

@freezed
class FaceIdSensorData with _$FaceIdSensorData {
  const factory FaceIdSensorData({
    @Uint8ListConverter() required Uint8List rgb,
    @Float64ListConverter() required Float64List xyz,
    @Float32ListConverter() required Float32List depthValues,
    required int width,
    required int height,
  }) = _FaceIdSensorData;

  factory FaceIdSensorData.fromJson(Map<String, dynamic> json) =>
      _$FaceIdSensorDataFromJson(json);

  @override
  Map<String, dynamic> toJson() => throw UnimplementedError();
}
