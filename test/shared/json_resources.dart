import 'dart:typed_data';

import 'package:cv_camera/cv_camera.dart';

abstract class JsonResources {
  static const nativeCameraImageJson = {
    "height": 2,
    "width": 2,
    "planes": [
      {
        "height": 2,
        "width": 2,
        "bytes": [1,2,3,4,1,2,3,4,1,2,3,4,1,2,3,4],
        "bytesPerRow": 2
      }
    ]
  };

  static final nativeCameraImageSerialized = CameraImage(
    width: 2,
    height: 2,
    planes: [
      Plane(
        width: 2,
        height: 2,
        bytes: Uint8List.fromList([1,2,3,4,1,2,3,4,1,2,3,4,1,2,3,4]),
        bytesPerRow: 2,
      )
    ],
  );
}