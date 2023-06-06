import 'package:freezed_annotation/freezed_annotation.dart';

part 'camera_pitch.freezed.dart';

@freezed
class CameraPitch with _$CameraPitch {
  const factory CameraPitch({
    required double x,
    required double y,
    required double z,
  }) = _CameraPitch;

  factory CameraPitch.fromJson(Map<String, dynamic> json) =>
      _$CameraPitchFromJson(json);
}
