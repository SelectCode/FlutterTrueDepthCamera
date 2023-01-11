// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cg_vector.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

CGVector _$CGVectorFromJson(Map<String, dynamic> json) {
  return _CGVector.fromJson(json);
}

/// @nodoc
mixin _$CGVector {
  double get x => throw _privateConstructorUsedError;
  double get y => throw _privateConstructorUsedError;
  double get z => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CGVectorCopyWith<CGVector> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CGVectorCopyWith<$Res> {
  factory $CGVectorCopyWith(CGVector value, $Res Function(CGVector) then) =
      _$CGVectorCopyWithImpl<$Res, CGVector>;
  @useResult
  $Res call({double x, double y, double z});
}

/// @nodoc
class _$CGVectorCopyWithImpl<$Res, $Val extends CGVector>
    implements $CGVectorCopyWith<$Res> {
  _$CGVectorCopyWithImpl(this._value, this._then);

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
abstract class _$$_CGVectorCopyWith<$Res> implements $CGVectorCopyWith<$Res> {
  factory _$$_CGVectorCopyWith(
          _$_CGVector value, $Res Function(_$_CGVector) then) =
      __$$_CGVectorCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double x, double y, double z});
}

/// @nodoc
class __$$_CGVectorCopyWithImpl<$Res>
    extends _$CGVectorCopyWithImpl<$Res, _$_CGVector>
    implements _$$_CGVectorCopyWith<$Res> {
  __$$_CGVectorCopyWithImpl(
      _$_CGVector _value, $Res Function(_$_CGVector) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? x = null,
    Object? y = null,
    Object? z = null,
  }) {
    return _then(_$_CGVector(
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
class _$_CGVector implements _CGVector {
  const _$_CGVector({required this.x, required this.y, required this.z});

  factory _$_CGVector.fromJson(Map<String, dynamic> json) =>
      _$$_CGVectorFromJson(json);

  @override
  final double x;
  @override
  final double y;
  @override
  final double z;

  @override
  String toString() {
    return 'CGVector(x: $x, y: $y, z: $z)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_CGVector &&
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
  _$$_CGVectorCopyWith<_$_CGVector> get copyWith =>
      __$$_CGVectorCopyWithImpl<_$_CGVector>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_CGVectorToJson(
      this,
    );
  }
}

abstract class _CGVector implements CGVector {
  const factory _CGVector(
      {required final double x,
      required final double y,
      required final double z}) = _$_CGVector;

  factory _CGVector.fromJson(Map<String, dynamic> json) = _$_CGVector.fromJson;

  @override
  double get x;
  @override
  double get y;
  @override
  double get z;
  @override
  @JsonKey(ignore: true)
  _$$_CGVectorCopyWith<_$_CGVector> get copyWith =>
      throw _privateConstructorUsedError;
}
