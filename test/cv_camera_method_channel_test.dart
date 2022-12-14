import 'package:cv_camera/src/controller/camera_controller_impl.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cv_camera/cv_camera_method_channel.dart';

void main() {
  MethodChannelCvCamera platform = MethodChannelCvCamera();
  const MethodChannel channel = MethodChannel('cv_camera');
  const EventChannel eventChannel = EventChannel('cv_camera/events');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('pass correct channels', () {
    final controller = platform.getCameraController() as CameraControllerImpl;
    expect(controller.methodChannel, channel);
    expect(controller.eventChannel, eventChannel);
  });
}
