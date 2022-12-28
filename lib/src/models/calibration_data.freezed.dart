// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'calibration_data.dart';

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

CvCameraCalibrationData _$CvCameraCalibrationDataFromJson(
    Map<String, dynamic> json) {
  return _CvCameraCalibrationData.fromJson(json);
}

/// @nodoc
mixin _$CvCameraCalibrationData {
  double get pixelSize => throw _privateConstructorUsedError;
  List<CGVector> get intrinsicMatrix => throw _privateConstructorUsedError;
  List<CGVector> get extrinsicMatrix => throw _privateConstructorUsedError;
  CGSize get intrinsicMatrixReferenceDimensions =>
      throw _privateConstructorUsedError;
  @Float64ListConverter()
  Float64List get lensDistortionLookupTable =>
      throw _privateConstructorUsedError;
  CGPoint get lensDistortionCenter => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CvCameraCalibrationDataCopyWith<CvCameraCalibrationData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CvCameraCalibrationDataCopyWith<$Res> {
  factory $CvCameraCalibrationDataCopyWith(CvCameraCalibrationData value,
          $Res Function(CvCameraCalibrationData) then) =
      _$CvCameraCalibrationDataCopyWithImpl<$Res, CvCameraCalibrationData>;
  @useResult
  $Res call(
      {double pixelSize,
      List<CGVector> intrinsicMatrix,
      List<CGVector> extrinsicMatrix,
      CGSize intrinsicMatrixReferenceDimensions,
      @Float64ListConverter() Float64List lensDistortionLookupTable,
      CGPoint lensDistortionCenter});

  $CGSizeCopyWith<$Res> get intrinsicMatrixReferenceDimensions;
  $CGPointCopyWith<$Res> get lensDistortionCenter;
}

/// @nodoc
class _$CvCameraCalibrationDataCopyWithImpl<$Res,
        $Val extends CvCameraCalibrationData>
    implements $CvCameraCalibrationDataCopyWith<$Res> {
  _$CvCameraCalibrationDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pixelSize = null,
    Object? intrinsicMatrix = null,
    Object? extrinsicMatrix = null,
    Object? intrinsicMatrixReferenceDimensions = null,
    Object? lensDistortionLookupTable = null,
    Object? lensDistortionCenter = null,
  }) {
    return _then(_value.copyWith(
      pixelSize: null == pixelSize
          ? _value.pixelSize
          : pixelSize // ignore: cast_nullable_to_non_nullable
              as double,
      intrinsicMatrix: null == intrinsicMatrix
          ? _value.intrinsicMatrix
          : intrinsicMatrix // ignore: cast_nullable_to_non_nullable
              as List<CGVector>,
      extrinsicMatrix: null == extrinsicMatrix
          ? _value.extrinsicMatrix
          : extrinsicMatrix // ignore: cast_nullable_to_non_nullable
              as List<CGVector>,
      intrinsicMatrixReferenceDimensions: null ==
              intrinsicMatrixReferenceDimensions
          ? _value.intrinsicMatrixReferenceDimensions
          : intrinsicMatrixReferenceDimensions // ignore: cast_nullable_to_non_nullable
              as CGSize,
      lensDistortionLookupTable: null == lensDistortionLookupTable
          ? _value.lensDistortionLookupTable
          : lensDistortionLookupTable // ignore: cast_nullable_to_non_nullable
              as Float64List,
      lensDistortionCenter: null == lensDistortionCenter
          ? _value.lensDistortionCenter
          : lensDistortionCenter // ignore: cast_nullable_to_non_nullable
              as CGPoint,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $CGSizeCopyWith<$Res> get intrinsicMatrixReferenceDimensions {
    return $CGSizeCopyWith<$Res>(_value.intrinsicMatrixReferenceDimensions,
        (value) {
      return _then(
          _value.copyWith(intrinsicMatrixReferenceDimensions: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $CGPointCopyWith<$Res> get lensDistortionCenter {
    return $CGPointCopyWith<$Res>(_value.lensDistortionCenter, (value) {
      return _then(_value.copyWith(lensDistortionCenter: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_CvCameraCalibrationDataCopyWith<$Res>
    implements $CvCameraCalibrationDataCopyWith<$Res> {
  factory _$$_CvCameraCalibrationDataCopyWith(_$_CvCameraCalibrationData value,
          $Res Function(_$_CvCameraCalibrationData) then) =
      __$$_CvCameraCalibrationDataCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double pixelSize,
      List<CGVector> intrinsicMatrix,
      List<CGVector> extrinsicMatrix,
      CGSize intrinsicMatrixReferenceDimensions,
      @Float64ListConverter() Float64List lensDistortionLookupTable,
      CGPoint lensDistortionCenter});

  @override
  $CGSizeCopyWith<$Res> get intrinsicMatrixReferenceDimensions;
  @override
  $CGPointCopyWith<$Res> get lensDistortionCenter;
}

/// @nodoc
class __$$_CvCameraCalibrationDataCopyWithImpl<$Res>
    extends _$CvCameraCalibrationDataCopyWithImpl<$Res,
        _$_CvCameraCalibrationData>
    implements _$$_CvCameraCalibrationDataCopyWith<$Res> {
  __$$_CvCameraCalibrationDataCopyWithImpl(_$_CvCameraCalibrationData _value,
      $Res Function(_$_CvCameraCalibrationData) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pixelSize = null,
    Object? intrinsicMatrix = null,
    Object? extrinsicMatrix = null,
    Object? intrinsicMatrixReferenceDimensions = null,
    Object? lensDistortionLookupTable = null,
    Object? lensDistortionCenter = null,
  }) {
    return _then(_$_CvCameraCalibrationData(
      pixelSize: null == pixelSize
          ? _value.pixelSize
          : pixelSize // ignore: cast_nullable_to_non_nullable
              as double,
      intrinsicMatrix: null == intrinsicMatrix
          ? _value._intrinsicMatrix
          : intrinsicMatrix // ignore: cast_nullable_to_non_nullable
              as List<CGVector>,
      extrinsicMatrix: null == extrinsicMatrix
          ? _value._extrinsicMatrix
          : extrinsicMatrix // ignore: cast_nullable_to_non_nullable
              as List<CGVector>,
      intrinsicMatrixReferenceDimensions: null ==
              intrinsicMatrixReferenceDimensions
          ? _value.intrinsicMatrixReferenceDimensions
          : intrinsicMatrixReferenceDimensions // ignore: cast_nullable_to_non_nullable
              as CGSize,
      lensDistortionLookupTable: null == lensDistortionLookupTable
          ? _value.lensDistortionLookupTable
          : lensDistortionLookupTable // ignore: cast_nullable_to_non_nullable
              as Float64List,
      lensDistortionCenter: null == lensDistortionCenter
          ? _value.lensDistortionCenter
          : lensDistortionCenter // ignore: cast_nullable_to_non_nullable
              as CGPoint,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_CvCameraCalibrationData implements _CvCameraCalibrationData {
  const _$_CvCameraCalibrationData(
      {required this.pixelSize,
      required final List<CGVector> intrinsicMatrix,
      required final List<CGVector> extrinsicMatrix,
      required this.intrinsicMatrixReferenceDimensions,
      @Float64ListConverter() required this.lensDistortionLookupTable,
      required this.lensDistortionCenter})
      : _intrinsicMatrix = intrinsicMatrix,
        _extrinsicMatrix = extrinsicMatrix;

  factory _$_CvCameraCalibrationData.fromJson(Map<String, dynamic> json) =>
      _$$_CvCameraCalibrationDataFromJson(json);

  @override
  final double pixelSize;
  final List<CGVector> _intrinsicMatrix;
  @override
  List<CGVector> get intrinsicMatrix {
    if (_intrinsicMatrix is EqualUnmodifiableListView) return _intrinsicMatrix;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_intrinsicMatrix);
  }

  final List<CGVector> _extrinsicMatrix;
  @override
  List<CGVector> get extrinsicMatrix {
    if (_extrinsicMatrix is EqualUnmodifiableListView) return _extrinsicMatrix;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_extrinsicMatrix);
  }

  @override
  final CGSize intrinsicMatrixReferenceDimensions;
  @override
  @Float64ListConverter()
  final Float64List lensDistortionLookupTable;
  @override
  final CGPoint lensDistortionCenter;

  @override
  String toString() {
    return 'CvCameraCalibrationData(pixelSize: $pixelSize, intrinsicMatrix: $intrinsicMatrix, extrinsicMatrix: $extrinsicMatrix, intrinsicMatrixReferenceDimensions: $intrinsicMatrixReferenceDimensions, lensDistortionLookupTable: $lensDistortionLookupTable, lensDistortionCenter: $lensDistortionCenter)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_CvCameraCalibrationData &&
            (identical(other.pixelSize, pixelSize) ||
                other.pixelSize == pixelSize) &&
            const DeepCollectionEquality()
                .equals(other._intrinsicMatrix, _intrinsicMatrix) &&
            const DeepCollectionEquality()
                .equals(other._extrinsicMatrix, _extrinsicMatrix) &&
            (identical(other.intrinsicMatrixReferenceDimensions,
                    intrinsicMatrixReferenceDimensions) ||
                other.intrinsicMatrixReferenceDimensions ==
                    intrinsicMatrixReferenceDimensions) &&
            const DeepCollectionEquality().equals(
                other.lensDistortionLookupTable, lensDistortionLookupTable) &&
            (identical(other.lensDistortionCenter, lensDistortionCenter) ||
                other.lensDistortionCenter == lensDistortionCenter));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      pixelSize,
      const DeepCollectionEquality().hash(_intrinsicMatrix),
      const DeepCollectionEquality().hash(_extrinsicMatrix),
      intrinsicMatrixReferenceDimensions,
      const DeepCollectionEquality().hash(lensDistortionLookupTable),
      lensDistortionCenter);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_CvCameraCalibrationDataCopyWith<_$_CvCameraCalibrationData>
      get copyWith =>
          __$$_CvCameraCalibrationDataCopyWithImpl<_$_CvCameraCalibrationData>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_CvCameraCalibrationDataToJson(
      this,
    );
  }
}

abstract class _CvCameraCalibrationData implements CvCameraCalibrationData {
  const factory _CvCameraCalibrationData(
          {required final double pixelSize,
          required final List<CGVector> intrinsicMatrix,
          required final List<CGVector> extrinsicMatrix,
          required final CGSize intrinsicMatrixReferenceDimensions,
          @Float64ListConverter()
              required final Float64List lensDistortionLookupTable,
          required final CGPoint lensDistortionCenter}) =
      _$_CvCameraCalibrationData;

  factory _CvCameraCalibrationData.fromJson(Map<String, dynamic> json) =
      _$_CvCameraCalibrationData.fromJson;

  @override
  double get pixelSize;
  @override
  List<CGVector> get intrinsicMatrix;
  @override
  List<CGVector> get extrinsicMatrix;
  @override
  CGSize get intrinsicMatrixReferenceDimensions;
  @override
  @Float64ListConverter()
  Float64List get lensDistortionLookupTable;
  @override
  CGPoint get lensDistortionCenter;
  @override
  @JsonKey(ignore: true)
  _$$_CvCameraCalibrationDataCopyWith<_$_CvCameraCalibrationData>
      get copyWith => throw _privateConstructorUsedError;
}
