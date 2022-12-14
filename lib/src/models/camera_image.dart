import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

import 'plane.dart';

part 'camera_image.freezed.dart';
part 'camera_image.g.dart';

@freezed
class CameraImage with _$CameraImage {
  const CameraImage._();

  const factory CameraImage({
    required int width,
    required int height,
    required List<Plane> planes,
  }) = _CameraImage;

  factory CameraImage.fromJson(Map<String, dynamic> json) => CameraImage(
    width: json["width"],
    height: json["height"],
    planes: (json["planes"] as List).map((plane) {
      final json = Map<String, dynamic>.from(plane);
      return Plane.fromJson(json);
    }).toList(),
  );

  Uint8List getBytes() {
    return planes[0].bytes;
  }

  @override
  Map<String, dynamic> toJson() => throw UnimplementedError();
}
