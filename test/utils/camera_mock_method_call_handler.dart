import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock_init.dart';

class MethodCallTracker {
  final List<MethodCall> calls = <MethodCall>[];

  void track(MethodCall call) {
    calls.add(call);
  }
}

MethodCallTracker setCameraMockMethodCallHandler(
  MethodChannel channel,
  Future<dynamic> Function(MethodCall call) handler, {
  bool countInit = false,
}) {
  final tracker = MethodCallTracker();
  channel.setMockMethodCallHandler(
    (call) async {
      if (countInit) {
        tracker.track(call);
      }

      final initResult = mockInit(call.method);
      if (initResult != null) {
        return initResult;
      }
      if (!countInit) tracker.track(call);
      return handler(call);
    },
  );
  return tracker;
}
