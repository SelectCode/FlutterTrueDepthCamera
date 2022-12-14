// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'plane.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Plane _$PlaneFromJson(Map<String, dynamic> json) {
  return _Plane.fromJson(json);
}

/// @nodoc
mixin _$Plane {
  int get width => throw _privateConstructorUsedError;
  int get height => throw _privateConstructorUsedError;
  @Uint8ListConverter()
  Uint8List get bytes => throw _privateConstructorUsedError;
  int get bytesPerRow => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PlaneCopyWith<Plane> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlaneCopyWith<$Res> {
  factory $PlaneCopyWith(Plane value, $Res Function(Plane) then) =
      _$PlaneCopyWithImpl<$Res, Plane>;
  @useResult
  $Res call(
      {int width,
      int height,
      @Uint8ListConverter() Uint8List bytes,
      int bytesPerRow});
}

/// @nodoc
class _$PlaneCopyWithImpl<$Res, $Val extends Plane>
    implements $PlaneCopyWith<$Res> {
  _$PlaneCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? width = null,
    Object? height = null,
    Object? bytes = null,
    Object? bytesPerRow = null,
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
      bytes: null == bytes
          ? _value.bytes
          : bytes // ignore: cast_nullable_to_non_nullable
              as Uint8List,
      bytesPerRow: null == bytesPerRow
          ? _value.bytesPerRow
          : bytesPerRow // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_PlaneCopyWith<$Res> implements $PlaneCopyWith<$Res> {
  factory _$$_PlaneCopyWith(_$_Plane value, $Res Function(_$_Plane) then) =
      __$$_PlaneCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int width,
      int height,
      @Uint8ListConverter() Uint8List bytes,
      int bytesPerRow});
}

/// @nodoc
class __$$_PlaneCopyWithImpl<$Res> extends _$PlaneCopyWithImpl<$Res, _$_Plane>
    implements _$$_PlaneCopyWith<$Res> {
  __$$_PlaneCopyWithImpl(_$_Plane _value, $Res Function(_$_Plane) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? width = null,
    Object? height = null,
    Object? bytes = null,
    Object? bytesPerRow = null,
  }) {
    return _then(_$_Plane(
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
      bytes: null == bytes
          ? _value.bytes
          : bytes // ignore: cast_nullable_to_non_nullable
              as Uint8List,
      bytesPerRow: null == bytesPerRow
          ? _value.bytesPerRow
          : bytesPerRow // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Plane implements _Plane {
  const _$_Plane(
      {required this.width,
      required this.height,
      @Uint8ListConverter() required this.bytes,
      required this.bytesPerRow});

  factory _$_Plane.fromJson(Map<String, dynamic> json) =>
      _$$_PlaneFromJson(json);

  @override
  final int width;
  @override
  final int height;
  @override
  @Uint8ListConverter()
  final Uint8List bytes;
  @override
  final int bytesPerRow;

  @override
  String toString() {
    return 'Plane(width: $width, height: $height, bytes: $bytes, bytesPerRow: $bytesPerRow)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Plane &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height) &&
            const DeepCollectionEquality().equals(other.bytes, bytes) &&
            (identical(other.bytesPerRow, bytesPerRow) ||
                other.bytesPerRow == bytesPerRow));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, width, height,
      const DeepCollectionEquality().hash(bytes), bytesPerRow);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_PlaneCopyWith<_$_Plane> get copyWith =>
      __$$_PlaneCopyWithImpl<_$_Plane>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_PlaneToJson(
      this,
    );
  }
}

abstract class _Plane implements Plane {
  const factory _Plane(
      {required final int width,
      required final int height,
      @Uint8ListConverter() required final Uint8List bytes,
      required final int bytesPerRow}) = _$_Plane;

  factory _Plane.fromJson(Map<String, dynamic> json) = _$_Plane.fromJson;

  @override
  int get width;
  @override
  int get height;
  @override
  @Uint8ListConverter()
  Uint8List get bytes;
  @override
  int get bytesPerRow;
  @override
  @JsonKey(ignore: true)
  _$$_PlaneCopyWith<_$_Plane> get copyWith =>
      throw _privateConstructorUsedError;
}
