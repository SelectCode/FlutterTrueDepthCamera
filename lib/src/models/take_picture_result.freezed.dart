// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'take_picture_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

TakePictureResult _$TakePictureResultFromJson(Map<String, dynamic> json) {
  return _TakePictureResult.fromJson(json);
}

/// @nodoc
mixin _$TakePictureResult {
  /// Is `null` when CameraDirection is not front
  @JsonKey(name: "depthData")
  FaceIdSensorData? get faceIdSensorData => throw _privateConstructorUsedError;
  @JsonKey(name: "image")
  CameraImage get cameraImage => throw _privateConstructorUsedError;
  CameraPitch get pitch => throw _privateConstructorUsedError;
  String? get path => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TakePictureResultCopyWith<TakePictureResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TakePictureResultCopyWith<$Res> {
  factory $TakePictureResultCopyWith(
          TakePictureResult value, $Res Function(TakePictureResult) then) =
      _$TakePictureResultCopyWithImpl<$Res, TakePictureResult>;
  @useResult
  $Res call(
      {@JsonKey(name: "depthData") FaceIdSensorData? faceIdSensorData,
      @JsonKey(name: "image") CameraImage cameraImage,
      CameraPitch pitch,
      String? path});

  $CameraPitchCopyWith<$Res> get pitch;
}

/// @nodoc
class _$TakePictureResultCopyWithImpl<$Res, $Val extends TakePictureResult>
    implements $TakePictureResultCopyWith<$Res> {
  _$TakePictureResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? faceIdSensorData = freezed,
    Object? cameraImage = freezed,
    Object? pitch = null,
    Object? path = freezed,
  }) {
    return _then(_value.copyWith(
      faceIdSensorData: freezed == faceIdSensorData
          ? _value.faceIdSensorData
          : faceIdSensorData // ignore: cast_nullable_to_non_nullable
              as FaceIdSensorData?,
      cameraImage: freezed == cameraImage
          ? _value.cameraImage
          : cameraImage // ignore: cast_nullable_to_non_nullable
              as CameraImage,
      pitch: null == pitch
          ? _value.pitch
          : pitch // ignore: cast_nullable_to_non_nullable
              as CameraPitch,
      path: freezed == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $CameraPitchCopyWith<$Res> get pitch {
    return $CameraPitchCopyWith<$Res>(_value.pitch, (value) {
      return _then(_value.copyWith(pitch: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_TakePictureResultCopyWith<$Res>
    implements $TakePictureResultCopyWith<$Res> {
  factory _$$_TakePictureResultCopyWith(_$_TakePictureResult value,
          $Res Function(_$_TakePictureResult) then) =
      __$$_TakePictureResultCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: "depthData") FaceIdSensorData? faceIdSensorData,
      @JsonKey(name: "image") CameraImage cameraImage,
      CameraPitch pitch,
      String? path});

  @override
  $CameraPitchCopyWith<$Res> get pitch;
}

/// @nodoc
class __$$_TakePictureResultCopyWithImpl<$Res>
    extends _$TakePictureResultCopyWithImpl<$Res, _$_TakePictureResult>
    implements _$$_TakePictureResultCopyWith<$Res> {
  __$$_TakePictureResultCopyWithImpl(
      _$_TakePictureResult _value, $Res Function(_$_TakePictureResult) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? faceIdSensorData = freezed,
    Object? cameraImage = freezed,
    Object? pitch = null,
    Object? path = freezed,
  }) {
    return _then(_$_TakePictureResult(
      faceIdSensorData: freezed == faceIdSensorData
          ? _value.faceIdSensorData
          : faceIdSensorData // ignore: cast_nullable_to_non_nullable
              as FaceIdSensorData?,
      cameraImage: freezed == cameraImage
          ? _value.cameraImage
          : cameraImage // ignore: cast_nullable_to_non_nullable
              as CameraImage,
      pitch: null == pitch
          ? _value.pitch
          : pitch // ignore: cast_nullable_to_non_nullable
              as CameraPitch,
      path: freezed == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_TakePictureResult implements _TakePictureResult {
  const _$_TakePictureResult(
      {@JsonKey(name: "depthData") required this.faceIdSensorData,
      @JsonKey(name: "image") required this.cameraImage,
      required this.pitch,
      this.path});

  factory _$_TakePictureResult.fromJson(Map<String, dynamic> json) =>
      _$$_TakePictureResultFromJson(json);

  /// Is `null` when CameraDirection is not front
  @override
  @JsonKey(name: "depthData")
  final FaceIdSensorData? faceIdSensorData;
  @override
  @JsonKey(name: "image")
  final CameraImage cameraImage;
  @override
  final CameraPitch pitch;
  @override
  final String? path;

  @override
  String toString() {
    return 'TakePictureResult(faceIdSensorData: $faceIdSensorData, cameraImage: $cameraImage, pitch: $pitch, path: $path)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_TakePictureResult &&
            const DeepCollectionEquality()
                .equals(other.faceIdSensorData, faceIdSensorData) &&
            const DeepCollectionEquality()
                .equals(other.cameraImage, cameraImage) &&
            (identical(other.pitch, pitch) || other.pitch == pitch) &&
            (identical(other.path, path) || other.path == path));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(faceIdSensorData),
      const DeepCollectionEquality().hash(cameraImage),
      pitch,
      path);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_TakePictureResultCopyWith<_$_TakePictureResult> get copyWith =>
      __$$_TakePictureResultCopyWithImpl<_$_TakePictureResult>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_TakePictureResultToJson(
      this,
    );
  }
}

abstract class _TakePictureResult implements TakePictureResult {
  const factory _TakePictureResult(
      {@JsonKey(name: "depthData")
          required final FaceIdSensorData? faceIdSensorData,
      @JsonKey(name: "image")
          required final CameraImage cameraImage,
      required final CameraPitch pitch,
      final String? path}) = _$_TakePictureResult;

  factory _TakePictureResult.fromJson(Map<String, dynamic> json) =
      _$_TakePictureResult.fromJson;

  @override

  /// Is `null` when CameraDirection is not front
  @JsonKey(name: "depthData")
  FaceIdSensorData? get faceIdSensorData;
  @override
  @JsonKey(name: "image")
  CameraImage get cameraImage;
  @override
  CameraPitch get pitch;
  @override
  String? get path;
  @override
  @JsonKey(ignore: true)
  _$$_TakePictureResultCopyWith<_$_TakePictureResult> get copyWith =>
      throw _privateConstructorUsedError;
}
