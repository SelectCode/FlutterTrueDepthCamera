import 'package:cv_camera/cv_camera.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  group('lens direction test', () {
    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
    });

    test('should set to front if front is passed', () {
      const direction = LensDirection.front;
      final controller = CvCamera.getCameraController(lensDirection: direction);
      expect(controller.lensDirection, direction);
    });

    test('should set to back if back is passed', () {
      const direction = LensDirection.back;
      final controller = CvCamera.getCameraController(lensDirection: direction);
      expect(controller.lensDirection, direction);
    });
  });
}
