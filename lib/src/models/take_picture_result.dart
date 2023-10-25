import 'package:cv_camera/cv_camera.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'camera_image.dart';
import 'face_id_sensor_data.dart';

part 'take_picture_result.freezed.dart';

part 'take_picture_result.g.dart';

@freezed
class TakePictureResult with _$TakePictureResult {
  const factory TakePictureResult({
    /// Is `null` when CameraDirection is not front
    @JsonKey(name: "depthData") required FaceIdSensorData? faceIdSensorData,
    @JsonKey(name: "image") required CameraImage cameraImage,
    required CameraPitch pitch,
    String? path,
  }) = _TakePictureResult;

  factory TakePictureResult.fromJson(Map<String, dynamic> json) =>
      _$TakePictureResultFromJson(json.map((key, value) {
        if (value is Map) {
          return MapEntry(key, Map<String, dynamic>.from(value));
        }
        return MapEntry(key, value);
      }));

  @override
  Map<String, dynamic> toJson() => throw UnimplementedError();
}
