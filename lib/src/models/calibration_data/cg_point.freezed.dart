// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cg_point.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

CGPoint _$CGPointFromJson(Map<String, dynamic> json) {
  return _CGPoint.fromJson(json);
}

/// @nodoc
mixin _$CGPoint {
  double get x => throw _privateConstructorUsedError;
  double get y => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CGPointCopyWith<CGPoint> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CGPointCopyWith<$Res> {
  factory $CGPointCopyWith(CGPoint value, $Res Function(CGPoint) then) =
      _$CGPointCopyWithImpl<$Res, CGPoint>;
  @useResult
  $Res call({double x, double y});
}

/// @nodoc
class _$CGPointCopyWithImpl<$Res, $Val extends CGPoint>
    implements $CGPointCopyWith<$Res> {
  _$CGPointCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? x = null,
    Object? y = null,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_CGPointCopyWith<$Res> implements $CGPointCopyWith<$Res> {
  factory _$$_CGPointCopyWith(
          _$_CGPoint value, $Res Function(_$_CGPoint) then) =
      __$$_CGPointCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double x, double y});
}

/// @nodoc
class __$$_CGPointCopyWithImpl<$Res>
    extends _$CGPointCopyWithImpl<$Res, _$_CGPoint>
    implements _$$_CGPointCopyWith<$Res> {
  __$$_CGPointCopyWithImpl(_$_CGPoint _value, $Res Function(_$_CGPoint) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? x = null,
    Object? y = null,
  }) {
    return _then(_$_CGPoint(
      x: null == x
          ? _value.x
          : x // ignore: cast_nullable_to_non_nullable
              as double,
      y: null == y
          ? _value.y
          : y // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_CGPoint implements _CGPoint {
  const _$_CGPoint({required this.x, required this.y});

  factory _$_CGPoint.fromJson(Map<String, dynamic> json) =>
      _$$_CGPointFromJson(json);

  @override
  final double x;
  @override
  final double y;

  @override
  String toString() {
    return 'CGPoint(x: $x, y: $y)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_CGPoint &&
            (identical(other.x, x) || other.x == x) &&
            (identical(other.y, y) || other.y == y));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, x, y);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_CGPointCopyWith<_$_CGPoint> get copyWith =>
      __$$_CGPointCopyWithImpl<_$_CGPoint>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_CGPointToJson(
      this,
    );
  }
}

abstract class _CGPoint implements CGPoint {
  const factory _CGPoint({required final double x, required final double y}) =
      _$_CGPoint;

  factory _CGPoint.fromJson(Map<String, dynamic> json) = _$_CGPoint.fromJson;

  @override
  double get x;
  @override
  double get y;
  @override
  @JsonKey(ignore: true)
  _$$_CGPointCopyWith<_$_CGPoint> get copyWith =>
      throw _privateConstructorUsedError;
}
