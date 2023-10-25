import 'dart:async';
import 'dart:math';

import 'package:sensors_plus/sensors_plus.dart';

import '../../../cv_camera.dart';

class PitchService {
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;

  Completer<CameraPitch> _lastPitchData = Completer();

  Future<CameraPitch> getPitch() async {
    return await _lastPitchData.future;
  }

  void startListening() {
    _accelerometerSubscription ??=
        accelerometerEvents.listen((AccelerometerEvent event) {
      final pitchData = _calculatePitch(event.x, event.y, event.z);
      _lastPitchData.complete(pitchData);
      _lastPitchData = Completer();
    });
  }

  void stopListening() {
    _accelerometerSubscription?.cancel();
    _accelerometerSubscription = null;
  }

  CameraPitch _calculatePitch(double x, double y, double z) {
    final pitchX = -1 * (180 / 3.14159) * atan2(x, sqrt(y * y + z * z));
    final pitchY = -1 * (180 / 3.14159) * atan2(y, sqrt(x * x + z * z));
    final pitchZ = -1 * (180 / 3.14159) * atan2(z, sqrt(x * x + y * y));
    return CameraPitch(
      x: pitchX,
      y: pitchY,
      z: pitchZ,
    );
  }
}
