// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'face_id_sensor_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

FaceIdSensorData _$FaceIdSensorDataFromJson(Map<String, dynamic> json) {
  return _FaceIdSensorData.fromJson(json);
}

/// @nodoc
mixin _$FaceIdSensorData {
  @Uint8ListConverter()
  Uint8List get rgb => throw _privateConstructorUsedError;
  @Float64ListConverter()
  Float64List get xyz => throw _privateConstructorUsedError;
  @Float32ListConverter()
  Float32List get depthValues => throw _privateConstructorUsedError;
  int get width => throw _privateConstructorUsedError;
  int get height => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FaceIdSensorDataCopyWith<FaceIdSensorData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FaceIdSensorDataCopyWith<$Res> {
  factory $FaceIdSensorDataCopyWith(
          FaceIdSensorData value, $Res Function(FaceIdSensorData) then) =
      _$FaceIdSensorDataCopyWithImpl<$Res, FaceIdSensorData>;
  @useResult
  $Res call(
      {@Uint8ListConverter() Uint8List rgb,
      @Float64ListConverter() Float64List xyz,
      @Float32ListConverter() Float32List depthValues,
      int width,
      int height});
}

/// @nodoc
class _$FaceIdSensorDataCopyWithImpl<$Res, $Val extends FaceIdSensorData>
    implements $FaceIdSensorDataCopyWith<$Res> {
  _$FaceIdSensorDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rgb = null,
    Object? xyz = null,
    Object? depthValues = null,
    Object? width = null,
    Object? height = null,
  }) {
    return _then(_value.copyWith(
      rgb: null == rgb
          ? _value.rgb
          : rgb // ignore: cast_nullable_to_non_nullable
              as Uint8List,
      xyz: null == xyz
          ? _value.xyz
          : xyz // ignore: cast_nullable_to_non_nullable
              as Float64List,
      depthValues: null == depthValues
          ? _value.depthValues
          : depthValues // ignore: cast_nullable_to_non_nullable
              as Float32List,
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_FaceIdSensorDataCopyWith<$Res>
    implements $FaceIdSensorDataCopyWith<$Res> {
  factory _$$_FaceIdSensorDataCopyWith(
          _$_FaceIdSensorData value, $Res Function(_$_FaceIdSensorData) then) =
      __$$_FaceIdSensorDataCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@Uint8ListConverter() Uint8List rgb,
      @Float64ListConverter() Float64List xyz,
      @Float32ListConverter() Float32List depthValues,
      int width,
      int height});
}

/// @nodoc
class __$$_FaceIdSensorDataCopyWithImpl<$Res>
    extends _$FaceIdSensorDataCopyWithImpl<$Res, _$_FaceIdSensorData>
    implements _$$_FaceIdSensorDataCopyWith<$Res> {
  __$$_FaceIdSensorDataCopyWithImpl(
      _$_FaceIdSensorData _value, $Res Function(_$_FaceIdSensorData) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rgb = null,
    Object? xyz = null,
    Object? depthValues = null,
    Object? width = null,
    Object? height = null,
  }) {
    return _then(_$_FaceIdSensorData(
      rgb: null == rgb
          ? _value.rgb
          : rgb // ignore: cast_nullable_to_non_nullable
              as Uint8List,
      xyz: null == xyz
          ? _value.xyz
          : xyz // ignore: cast_nullable_to_non_nullable
              as Float64List,
      depthValues: null == depthValues
          ? _value.depthValues
          : depthValues // ignore: cast_nullable_to_non_nullable
              as Float32List,
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_FaceIdSensorData implements _FaceIdSensorData {
  const _$_FaceIdSensorData(
      {@Uint8ListConverter() required this.rgb,
      @Float64ListConverter() required this.xyz,
      @Float32ListConverter() required this.depthValues,
      required this.width,
      required this.height});

  factory _$_FaceIdSensorData.fromJson(Map<String, dynamic> json) =>
      _$$_FaceIdSensorDataFromJson(json);

  @override
  @Uint8ListConverter()
  final Uint8List rgb;
  @override
  @Float64ListConverter()
  final Float64List xyz;
  @override
  @Float32ListConverter()
  final Float32List depthValues;
  @override
  final int width;
  @override
  final int height;

  @override
  String toString() {
    return 'FaceIdSensorData(rgb: $rgb, xyz: $xyz, depthValues: $depthValues, width: $width, height: $height)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_FaceIdSensorData &&
            const DeepCollectionEquality().equals(other.rgb, rgb) &&
            const DeepCollectionEquality().equals(other.xyz, xyz) &&
            const DeepCollectionEquality()
                .equals(other.depthValues, depthValues) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(rgb),
      const DeepCollectionEquality().hash(xyz),
      const DeepCollectionEquality().hash(depthValues),
      width,
      height);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_FaceIdSensorDataCopyWith<_$_FaceIdSensorData> get copyWith =>
      __$$_FaceIdSensorDataCopyWithImpl<_$_FaceIdSensorData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_FaceIdSensorDataToJson(
      this,
    );
  }
}

abstract class _FaceIdSensorData implements FaceIdSensorData {
  const factory _FaceIdSensorData(
      {@Uint8ListConverter() required final Uint8List rgb,
      @Float64ListConverter() required final Float64List xyz,
      @Float32ListConverter() required final Float32List depthValues,
      required final int width,
      required final int height}) = _$_FaceIdSensorData;

  factory _FaceIdSensorData.fromJson(Map<String, dynamic> json) =
      _$_FaceIdSensorData.fromJson;

  @override
  @Uint8ListConverter()
  Uint8List get rgb;
  @override
  @Float64ListConverter()
  Float64List get xyz;
  @override
  @Float32ListConverter()
  Float32List get depthValues;
  @override
  int get width;
  @override
  int get height;
  @override
  @JsonKey(ignore: true)
  _$$_FaceIdSensorDataCopyWith<_$_FaceIdSensorData> get copyWith =>
      throw _privateConstructorUsedError;
}
