import 'package:cv_camera/src/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../controller/camera_controller.dart';

class CameraPreview extends StatefulWidget {
  const CameraPreview({
    Key? key,
    required this.controller,
    this.child,
  }) : super(key: key);

  final CameraController controller;
  final Widget? child;

  @override
  State<CameraPreview> createState() => _CameraPreviewState();
}

class _CameraPreviewState extends State<CameraPreview> {
  @override
  Widget build(BuildContext context) {
    // This is used in the platform side to register the view.
    const String viewType = 'camera';
    // Pass parameters to the platform side.
    final Map<String, dynamic> creationParams = {
      "lensDirection": widget.controller.lensDirection.value,
    };

    return Stack(
      children: [
        UiKitView(
          viewType: viewType,
          creationParams: creationParams,
          creationParamsCodec: const StandardMessageCodec(),
        ),
        if (widget.child != null) widget.child!
      ],
    );
  }
}
