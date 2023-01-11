import 'package:cv_camera/cv_camera.dart';
import 'package:cv_camera/cv_camera_method_channel.dart';
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
      (call) async {},
    );
    sut = await setUpCameraController(platform: platform);
  });

  void expectMinCoverageThrows(double minCoverage) {
    expect(
      () => sut.checkForObject(
        minCoverage: minCoverage,
        depthValues: TakePictureTestResources.depthDataSerialized.depthValues,
      ),
      throwsA(
        predicate<RangeError>(
          (error) => error.message == 'minCoverage must be between 0 and 1',
        ),
      ),
    );
  }

  test('should throw error on minCoverage < 0', () {
    expectMinCoverageThrows(-0.01);
  });

  test('should throw error on minCoverage > 1', () {
    expectMinCoverageThrows(1.01);
  });

  test('should not throw error on valid minCoverage', () {
    expect(
      () => sut.checkForObject(
        minCoverage: 0,
        depthValues: TakePictureTestResources.depthDataSerialized.depthValues,
      ),
      returnsNormally,
    );

    expect(
      () => sut.checkForObject(
        minCoverage: 1,
        depthValues: TakePictureTestResources.depthDataSerialized.depthValues,
      ),
      returnsNormally,
    );
  });
}
