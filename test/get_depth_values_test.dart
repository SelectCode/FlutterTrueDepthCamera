import 'dart:typed_data';

import 'package:cv_camera/cv_camera.dart';
import 'package:cv_camera/cv_camera_method_channel.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'take_picture_test.dart';
import 'utils/camera_mock_method_call_handler.dart';
import 'utils/set_up_camera_controller.dart';

void main() {
  late CameraController sut;
  late MethodCallTracker tracker;
  final depthValues = Float32List.fromList([1.0]);
  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final platform = MethodChannelCvCamera();
    tracker = setCameraMockMethodCallHandler(
      platform.methodChannel,
      (call) async {
        if (call.method == 'get_depth_values') {
          return depthValues;
        }
      },
    );
    sut = await setUpCameraController(platform: platform);
  });

  test('should call get_depth_values', () async {
    await sut.getDepthValues();
    expect(
      tracker.calls,
      contains(
        predicate<MethodCall>((p0) => p0.method == 'get_depth_values'),
      ),
    );
  });

  test('should return correct DepthValues', () async {
    final result = await sut.getDepthValues();
    expect(result, TakePictureTestResources.depthDataSerialized.depthValues);
  });

  test('should emit three snapshots', () async {
    final stream = sut.getDepthValueStream(100);

    final startTime = DateTime.now();
    final snapshots = await stream.take(3).toList();
    final endTime = DateTime.now();
    final duration = endTime.difference(startTime).inMilliseconds;
    expect(duration, lessThan(350));
    expect(duration, greaterThan(299));

    expect(snapshots.length, 3);
    expect(snapshots, List.filled(3, depthValues.toList()));
  });
}
