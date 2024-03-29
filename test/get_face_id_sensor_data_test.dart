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
  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final platform = MethodChannelCvCamera();
    tracker = setCameraMockMethodCallHandler(
      platform.methodChannel,
      (call) async {
        if (call.method == 'get_face_id_sensor_data') {
          return TakePictureTestResources.depthDataJson;
        }
      },
    );
    sut = await setUpCameraController(platform: platform);
  });

  test('should call get_face_id_sensor_data', () async {
    await sut.getFaceIdSensorData();
    expect(
      tracker.calls,
      contains(
        predicate<MethodCall>((p0) => p0.method == 'get_face_id_sensor_data'),
      ),
    );
  });

  test('should return correct FaceIdSensorData', () async {
    final result = await sut.getFaceIdSensorData();
    expect(result, TakePictureTestResources.depthDataSerialized);
  });
}
