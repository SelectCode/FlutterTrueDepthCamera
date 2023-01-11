import 'dart:typed_data';

import 'package:cv_camera/cv_camera.dart';
import 'package:cv_camera/cv_camera_method_channel.dart';
import 'package:cv_camera/src/models/calibration_data/calibration_data.dart';
import 'package:cv_camera/src/models/calibration_data/cg_point.dart';
import 'package:cv_camera/src/models/calibration_data/cg_size.dart';
import 'package:cv_camera/src/models/calibration_data/cg_vector.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils/camera_mock_method_call_handler.dart';
import 'utils/set_up_camera_controller.dart';

final CvCameraCalibrationData _calibrationData = CvCameraCalibrationData(
  pixelSize: 2,
  intrinsicMatrix: [
    const CGVector(x: 1, y: 2, z: 3),
    const CGVector(x: 4, y: 5, z: 6),
    const CGVector(x: 7, y: 8, z: 9),
  ],
  extrinsicMatrix: [
    const CGVector(x: 1, y: 2, z: 3),
    const CGVector(x: 4, y: 5, z: 6),
    const CGVector(x: 7, y: 8, z: 9),
  ],
  intrinsicMatrixReferenceDimensions: const CGSize(width: 1, height: 2),
  lensDistortionLookupTable: Float64List.fromList([1, 2, 3, 4, 5, 6, 7, 8, 9]),
  lensDistortionCenter: const CGPoint(x: 1, y: 2),
);

void main() {
  late CameraController sut;
  late MethodCallTracker tracker;
  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final platform = MethodChannelCvCamera();
    tracker = setCameraMockMethodCallHandler(
      platform.methodChannel,
      (call) async {
        if (call.method == 'get_calibration_data') {
          return _calibrationData.toJson();
        }
      },
    );
    sut = await setUpCameraController(platform: platform);
  });

  test('should call get_calibration_data', () async {
    await sut.getCalibrationData();
    expect(
      tracker.calls,
      contains(
        predicate<MethodCall>(
          (call) => call.method == 'get_calibration_data',
        ),
      ),
    );
  });

  test('should return correct calibration data', () async {
    final result = await sut.getCalibrationData();
    expect(result, _calibrationData);
  });
}
