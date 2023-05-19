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
    Object? intrinsicMatrixReferenceDimensions = freezed,
    Object? lensDistortionLookupTable = null,
    Object? lensDistortionCenter = freezed,
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
      intrinsicMatrixReferenceDimensions: freezed ==
              intrinsicMatrixReferenceDimensions
          ? _value.intrinsicMatrixReferenceDimensions
          : intrinsicMatrixReferenceDimensions // ignore: cast_nullable_to_non_nullable
              as CGSize,
      lensDistortionLookupTable: null == lensDistortionLookupTable
          ? _value.lensDistortionLookupTable
          : lensDistortionLookupTable // ignore: cast_nullable_to_non_nullable
              as Float64List,
      lensDistortionCenter: freezed == lensDistortionCenter
          ? _value.lensDistortionCenter
          : lensDistortionCenter // ignore: cast_nullable_to_non_nullable
              as CGPoint,
    ) as $Val);
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
    Object? intrinsicMatrixReferenceDimensions = freezed,
    Object? lensDistortionLookupTable = null,
    Object? lensDistortionCenter = freezed,
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
      intrinsicMatrixReferenceDimensions: freezed ==
              intrinsicMatrixReferenceDimensions
          ? _value.intrinsicMatrixReferenceDimensions
          : intrinsicMatrixReferenceDimensions // ignore: cast_nullable_to_non_nullable
              as CGSize,
      lensDistortionLookupTable: null == lensDistortionLookupTable
          ? _value.lensDistortionLookupTable
          : lensDistortionLookupTable // ignore: cast_nullable_to_non_nullable
              as Float64List,
      lensDistortionCenter: freezed == lensDistortionCenter
          ? _value.lensDistortionCenter
          : lensDistortionCenter // ignore: cast_nullable_to_non_nullable
              as CGPoint,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true)
class _$_CvCameraCalibrationData extends _CvCameraCalibrationData {
  const _$_CvCameraCalibrationData(
      {required this.pixelSize,
      required final List<CGVector> intrinsicMatrix,
      required final List<CGVector> extrinsicMatrix,
      required this.intrinsicMatrixReferenceDimensions,
      @Float64ListConverter() required this.lensDistortionLookupTable,
      required this.lensDistortionCenter})
      : _intrinsicMatrix = intrinsicMatrix,
        _extrinsicMatrix = extrinsicMatrix,
        super._();

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
            const DeepCollectionEquality().equals(
                other.intrinsicMatrixReferenceDimensions,
                intrinsicMatrixReferenceDimensions) &&
            const DeepCollectionEquality().equals(
                other.lensDistortionLookupTable, lensDistortionLookupTable) &&
            const DeepCollectionEquality()
                .equals(other.lensDistortionCenter, lensDistortionCenter));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      pixelSize,
      const DeepCollectionEquality().hash(_intrinsicMatrix),
      const DeepCollectionEquality().hash(_extrinsicMatrix),
      const DeepCollectionEquality().hash(intrinsicMatrixReferenceDimensions),
      const DeepCollectionEquality().hash(lensDistortionLookupTable),
      const DeepCollectionEquality().hash(lensDistortionCenter));

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

abstract class _CvCameraCalibrationData extends CvCameraCalibrationData {
  const factory _CvCameraCalibrationData(
          {required final double pixelSize,
          required final List<CGVector> intrinsicMatrix,
          required final List<CGVector> extrinsicMatrix,
          required final CGSize intrinsicMatrixReferenceDimensions,
          @Float64ListConverter()
              required final Float64List lensDistortionLookupTable,
          required final CGPoint lensDistortionCenter}) =
      _$_CvCameraCalibrationData;
  const _CvCameraCalibrationData._() : super._();

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
