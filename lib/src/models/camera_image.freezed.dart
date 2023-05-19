// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'camera_image.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

CameraImage _$CameraImageFromJson(Map<String, dynamic> json) {
  return _CameraImage.fromJson(json);
}

/// @nodoc
mixin _$CameraImage {
  int get width => throw _privateConstructorUsedError;
  int get height => throw _privateConstructorUsedError;
  List<Plane> get planes => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CameraImageCopyWith<CameraImage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CameraImageCopyWith<$Res> {
  factory $CameraImageCopyWith(
          CameraImage value, $Res Function(CameraImage) then) =
      _$CameraImageCopyWithImpl<$Res, CameraImage>;
  @useResult
  $Res call({int width, int height, List<Plane> planes});
}

/// @nodoc
class _$CameraImageCopyWithImpl<$Res, $Val extends CameraImage>
    implements $CameraImageCopyWith<$Res> {
  _$CameraImageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? width = null,
    Object? height = null,
    Object? planes = null,
  }) {
    return _then(_value.copyWith(
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
      planes: null == planes
          ? _value.planes
          : planes // ignore: cast_nullable_to_non_nullable
              as List<Plane>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_CameraImageCopyWith<$Res>
    implements $CameraImageCopyWith<$Res> {
  factory _$$_CameraImageCopyWith(
          _$_CameraImage value, $Res Function(_$_CameraImage) then) =
      __$$_CameraImageCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int width, int height, List<Plane> planes});
}

/// @nodoc
class __$$_CameraImageCopyWithImpl<$Res>
    extends _$CameraImageCopyWithImpl<$Res, _$_CameraImage>
    implements _$$_CameraImageCopyWith<$Res> {
  __$$_CameraImageCopyWithImpl(
      _$_CameraImage _value, $Res Function(_$_CameraImage) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? width = null,
    Object? height = null,
    Object? planes = null,
  }) {
    return _then(_$_CameraImage(
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
      planes: null == planes
          ? _value._planes
          : planes // ignore: cast_nullable_to_non_nullable
              as List<Plane>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_CameraImage extends _CameraImage {
  const _$_CameraImage(
      {required this.width,
      required this.height,
      required final List<Plane> planes})
      : _planes = planes,
        super._();

  factory _$_CameraImage.fromJson(Map<String, dynamic> json) =>
      _$$_CameraImageFromJson(json);

  @override
  final int width;
  @override
  final int height;
  final List<Plane> _planes;
  @override
  List<Plane> get planes {
    if (_planes is EqualUnmodifiableListView) return _planes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_planes);
  }

  @override
  String toString() {
    return 'CameraImage(width: $width, height: $height, planes: $planes)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_CameraImage &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height) &&
            const DeepCollectionEquality().equals(other._planes, _planes));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, width, height, const DeepCollectionEquality().hash(_planes));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_CameraImageCopyWith<_$_CameraImage> get copyWith =>
      __$$_CameraImageCopyWithImpl<_$_CameraImage>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_CameraImageToJson(
      this,
    );
  }
}

abstract class _CameraImage extends CameraImage {
  const factory _CameraImage(
      {required final int width,
      required final int height,
      required final List<Plane> planes}) = _$_CameraImage;
  const _CameraImage._() : super._();

  factory _CameraImage.fromJson(Map<String, dynamic> json) =
      _$_CameraImage.fromJson;

  @override
  int get width;
  @override
  int get height;
  @override
  List<Plane> get planes;
  @override
  @JsonKey(ignore: true)
  _$$_CameraImageCopyWith<_$_CameraImage> get copyWith =>
      throw _privateConstructorUsedError;
}
