// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'camera_pitch.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

CameraPitch _$CameraPitchFromJson(Map<String, dynamic> json) {
  return _CameraPitch.fromJson(json);
}

/// @nodoc
mixin _$CameraPitch {
  double get x => throw _privateConstructorUsedError;
  double get y => throw _privateConstructorUsedError;
  double get z => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CameraPitchCopyWith<CameraPitch> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CameraPitchCopyWith<$Res> {
  factory $CameraPitchCopyWith(
          CameraPitch value, $Res Function(CameraPitch) then) =
      _$CameraPitchCopyWithImpl<$Res, CameraPitch>;
  @useResult
  $Res call({double x, double y, double z});
}

/// @nodoc
class _$CameraPitchCopyWithImpl<$Res, $Val extends CameraPitch>
    implements $CameraPitchCopyWith<$Res> {
  _$CameraPitchCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? x = null,
    Object? y = null,
    Object? z = null,
  }) {
    return _then(_value.copyWith(
      x: null == x
          ? _value.x
          : x // ignore: cast_nullable_to_non_nullable
              as double,
      y: null == y
          ? _value.y
          : y // ignore: cast_nullable_to_non_nullable
              as double,
      z: null == z
          ? _value.z
          : z // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_CameraPitchCopyWith<$Res>
    implements $CameraPitchCopyWith<$Res> {
  factory _$$_CameraPitchCopyWith(
          _$_CameraPitch value, $Res Function(_$_CameraPitch) then) =
      __$$_CameraPitchCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double x, double y, double z});
}

/// @nodoc
class __$$_CameraPitchCopyWithImpl<$Res>
    extends _$CameraPitchCopyWithImpl<$Res, _$_CameraPitch>
    implements _$$_CameraPitchCopyWith<$Res> {
  __$$_CameraPitchCopyWithImpl(
      _$_CameraPitch _value, $Res Function(_$_CameraPitch) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? x = null,
    Object? y = null,
    Object? z = null,
  }) {
    return _then(_$_CameraPitch(
      x: null == x
          ? _value.x
          : x // ignore: cast_nullable_to_non_nullable
              as double,
      y: null == y
          ? _value.y
          : y // ignore: cast_nullable_to_non_nullable
              as double,
      z: null == z
          ? _value.z
          : z // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_CameraPitch implements _CameraPitch {
  const _$_CameraPitch({required this.x, required this.y, required this.z});

  factory _$_CameraPitch.fromJson(Map<String, dynamic> json) =>
      _$$_CameraPitchFromJson(json);

  @override
  final double x;
  @override
  final double y;
  @override
  final double z;

  @override
  String toString() {
    return 'CameraPitch(x: $x, y: $y, z: $z)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_CameraPitch &&
            (identical(other.x, x) || other.x == x) &&
            (identical(other.y, y) || other.y == y) &&
            (identical(other.z, z) || other.z == z));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, x, y, z);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_CameraPitchCopyWith<_$_CameraPitch> get copyWith =>
      __$$_CameraPitchCopyWithImpl<_$_CameraPitch>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_CameraPitchToJson(
      this,
    );
  }
}

abstract class _CameraPitch implements CameraPitch {
  const factory _CameraPitch(
      {required final double x,
      required final double y,
      required final double z}) = _$_CameraPitch;

  factory _CameraPitch.fromJson(Map<String, dynamic> json) =
      _$_CameraPitch.fromJson;

  @override
  double get x;
  @override
  double get y;
  @override
  double get z;
  @override
  @JsonKey(ignore: true)
  _$$_CameraPitchCopyWith<_$_CameraPitch> get copyWith =>
      throw _privateConstructorUsedError;
}
