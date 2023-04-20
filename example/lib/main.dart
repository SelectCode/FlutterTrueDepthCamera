import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cv_camera/cv_camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_extend/share_extend.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final CameraController _controller;

  late final StreamSubscription<CameraImage> _cameraImageStream;
  late final CameraShootEffectController _shootEffectController;

  @override
  void initState() {
    super.initState();
    _controller =
        CvCamera.getCameraController(enableDistortionCorrection: false);
    _shootEffectController = CameraShootEffectController();
    setUpStream();
  }

  void setUpStream() async {
    final stream = await _controller.startImageStream();
    _cameraImageStream = stream.listen((image) {});
  }

  @override
  void dispose() {
    _shootEffectController.dispose();
    _cameraImageStream.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<void> shareFaceIdData(
      TakePictureResult result, BuildContext context) async {
    print('writing to file');
    final filepath = await writePlyFile(result.faceIdSensorData!);
    final bytes = ImageBuilder.fromCameraImage(result.cameraImage).asJpg();
    final imagePath = await writeImageFile(bytes);

    await ShareExtend.shareMultiple([
      filepath,
      imagePath,
    ], 'file');
    showCopiedToClipboardNotification(context);
  }

  Future<void> copyCalibrationData(
      CvCameraCalibrationData? calibrationData, BuildContext context) async {
    await Clipboard.setData(ClipboardData(
      text: jsonEncode(calibrationData?.toJson()),
    ));
    showCopiedToClipboardNotification(context);
  }

  Future<void> showCopiedToClipboardNotification(BuildContext context) async {
    const snackBar = SnackBar(
      content: Text('Copied data to clipboard'),
      backgroundColor: Colors.green,
      margin: EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Cv camera example app'),
        ),
        body: SafeArea(
          child: Builder(builder: (context) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.camera),
                      onPressed: () async {
                        _shootEffectController.play();
                        final result = await _controller.takePicture();
                        await shareFaceIdData(result, context);
                        var notZeroCount = 0;
                        var depthValues = result.faceIdSensorData!.depthValues;
                        for (var i = 0; i < depthValues.length; i++) {
                          if (depthValues[i] != 0) {
                            notZeroCount++;
                          }
                        }
                        print("Out of ${depthValues.length} values, "
                            "$notZeroCount are not zero.");
                        await showModalBottomSheet(
                          context: context,
                          builder: (context) => SizedBox(
                            height: MediaQuery.of(context).size.height * 0.7,
                            child: Image.file(File(result.path)),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.compass_calibration),
                      onPressed: () async {
                        final result = await _controller.getCalibrationData();
                        await copyCalibrationData(result, context);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.face),
                      onPressed: () async {
                        final result = await _controller.getFaceIdSensorData();
                        // await copyFaceIdData(result, context);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.switch_camera_outlined),
                      onPressed: () async {
                        final lensDirection = _controller.lensDirection;
                        if (lensDirection == LensDirection.front) {
                          await _controller
                              .setLensDirection(LensDirection.back);
                        } else {
                          await _controller
                              .setLensDirection(LensDirection.front);
                        }
                      },
                    )
                  ],
                ),
                Expanded(
                  child: Stack(
                    children: [
                      CameraPreview(
                        shootEffectController: _shootEffectController,
                        controller: _controller,
                      ),
                      Center(
                        child: ObjectDetectionDisplay(
                          controller: _controller,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class ObjectDetectionDisplay extends StatefulWidget {
  const ObjectDetectionDisplay({Key? key, required this.controller})
      : super(key: key);

  final CameraController controller;

  @override
  State<ObjectDetectionDisplay> createState() => _ObjectDetectionDisplayState();
}

class _ObjectDetectionDisplayState extends State<ObjectDetectionDisplay> {
  late StreamSubscription<bool> _sensorStream;

  @override
  void initState() {
    super.initState();
    _initStream();
  }

  Future<void> _initStream() async {
    _sensorStream = (await widget.controller.startObjectDetectionStream())
        .listen((isDetecting) {
      setState(() {
        isDetectingObject = isDetecting;
      });
    });
  }

  @override
  void dispose() {
    _sensorStream.cancel();
    super.dispose();
  }

  bool isDetectingObject = false;

  @override
  Widget build(BuildContext context) {
    return isDetectingObject
        ? const Text('Detecting Object')
        : const Text('Not Detecting Object');
  }
}
