// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cg_size.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

CGSize _$CGSizeFromJson(Map<String, dynamic> json) {
  return _CGSize.fromJson(json);
}

/// @nodoc
mixin _$CGSize {
  double get width => throw _privateConstructorUsedError;
  double get height => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CGSizeCopyWith<CGSize> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CGSizeCopyWith<$Res> {
  factory $CGSizeCopyWith(CGSize value, $Res Function(CGSize) then) =
      _$CGSizeCopyWithImpl<$Res, CGSize>;
  @useResult
  $Res call({double width, double height});
}

/// @nodoc
class _$CGSizeCopyWithImpl<$Res, $Val extends CGSize>
    implements $CGSizeCopyWith<$Res> {
  _$CGSizeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? width = null,
    Object? height = null,
  }) {
    return _then(_value.copyWith(
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as double,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_CGSizeCopyWith<$Res> implements $CGSizeCopyWith<$Res> {
  factory _$$_CGSizeCopyWith(_$_CGSize value, $Res Function(_$_CGSize) then) =
      __$$_CGSizeCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double width, double height});
}

/// @nodoc
class __$$_CGSizeCopyWithImpl<$Res>
    extends _$CGSizeCopyWithImpl<$Res, _$_CGSize>
    implements _$$_CGSizeCopyWith<$Res> {
  __$$_CGSizeCopyWithImpl(_$_CGSize _value, $Res Function(_$_CGSize) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? width = null,
    Object? height = null,
  }) {
    return _then(_$_CGSize(
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as double,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_CGSize implements _CGSize {
  const _$_CGSize({required this.width, required this.height});

  factory _$_CGSize.fromJson(Map<String, dynamic> json) =>
      _$$_CGSizeFromJson(json);

  @override
  final double width;
  @override
  final double height;

  @override
  String toString() {
    return 'CGSize(width: $width, height: $height)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_CGSize &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, width, height);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_CGSizeCopyWith<_$_CGSize> get copyWith =>
      __$$_CGSizeCopyWithImpl<_$_CGSize>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_CGSizeToJson(
      this,
    );
  }
}

abstract class _CGSize implements CGSize {
  const factory _CGSize(
      {required final double width, required final double height}) = _$_CGSize;

  factory _CGSize.fromJson(Map<String, dynamic> json) = _$_CGSize.fromJson;

  @override
  double get width;
  @override
  double get height;
  @override
  @JsonKey(ignore: true)
  _$$_CGSizeCopyWith<_$_CGSize> get copyWith =>
      throw _privateConstructorUsedError;
}
