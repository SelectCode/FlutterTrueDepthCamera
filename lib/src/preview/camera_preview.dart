import 'package:cv_camera/src/misc/camera_shoot_effect.dart';
import 'package:cv_camera/src/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../controller/camera_controller.dart';

class CameraPreview extends StatefulWidget {
  const CameraPreview({
    Key? key,
    required this.controller,
    this.child,
    this.shootEffectController,
  }) : super(key: key);

  final CameraController controller;
  final Widget? child;
  final CameraShootEffectController? shootEffectController;

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
      "enableDistortionCorrection":
          widget.controller.enableDistortionCorrection,
      "objectDetectionOptions":
          widget.controller.objectDetectionOptions.toJson(),
      "preferredResolution": widget.controller.preferredResolution.name,
      "preferredFrameRate": widget.controller.preferredFrameRate.name,
      "useDepthCamera": widget.controller.useDepthCamera,
    };

    return Stack(
      children: [
        UiKitView(
          viewType: viewType,
          creationParams: creationParams,
          creationParamsCodec: const StandardMessageCodec(),
        ),
        if (widget.child != null) widget.child!,
        if (widget.shootEffectController != null)
          Center(
            child: CameraShootEffect(controller: widget.shootEffectController!),
          )
      ],
    );
  }
}
