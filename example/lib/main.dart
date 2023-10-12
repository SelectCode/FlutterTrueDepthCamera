import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cv_camera/cv_camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_extend/share_extend.dart';
import 'package:video_player/video_player.dart';

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
    _controller = CvCamera.getCameraController(
      enableDistortionCorrection: false,
      // objectDetectionOptions: const ObjectDetectionOptions(
      //   minDepth: 0.21,
      //   maxDepth: 0.45,
      //   centerWidthStart: 0.3,
      //   centerWidthEnd: 0.7,
      //   centerHeightStart: 0.2,
      //   centerHeightEnd: 0.8,
      //   minCoverage: 0.5,
      // ),
      preferredResolution: PreferredResolution.x1920x1080,
      lensDirection: LensDirection.back,
      preferredFrameRate: PreferredFrameRate.fps240,
    );
    _shootEffectController = CameraShootEffectController();
    // setUpStream();
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
    // final filepath = await writePlyFile(result.faceIdSensorData!);
    final bytes = ImageBuilder.fromCameraImage(result.cameraImage).asJpg();
    final imagePath = await writeImageFile(bytes);

    await ShareExtend.shareMultiple([
      // filepath,
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
                        final result =
                            await _controller.takePicture(saveImage: true);
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
                            child: Image.file(File(result.path!)),
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
                    ),
                    IconButton(
                      icon: const Icon(Icons.play_circle),
                      onPressed: () async {
                        await _controller.startMovieRecording();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.stop_circle),
                      onPressed: () async {
                        final url = await _controller.stopMovieRecording();
                        debugPrint(url);
                        await showModalBottomSheet(
                          context: context,
                          builder: (context) => SizedBox(
                            height: MediaQuery.of(context).size.height * 0.7,
                            child: _VideoPlayer(url: url),
                          ),
                        );
                        await ShareExtend.share(url, 'video');
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
                        child: Positioned.fill(child:
                            LayoutBuilder(builder: (context, constraints) {
                          final widthStart = constraints.maxWidth * 0.3;
                          final widthEnd = constraints.maxWidth * 0.7;
                          final heightStart = constraints.maxHeight * 0.2;
                          final heightEnd = constraints.maxHeight * 0.8;

                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.red,
                                width: 2,
                              ),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  left: widthStart,
                                  top: heightStart,
                                  child: Container(
                                    width: widthEnd - widthStart,
                                    height: heightEnd - heightStart,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.red,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        })),
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
  late StreamSubscription _sensorStream;

  String objectDetectionState = 'Not Detecting Object';

  @override
  void initState() {
    super.initState();
    _initStream();
  }

  Future<void> _initStream() async {
    _sensorStream =
        (await widget.controller.startObjectCoverageStream()).listen((result) {
      final coverage =
          result.insideBound.toDouble() / result.boundPointCount.toDouble();
      setState(() {
        if (coverage > 0.5) {
          objectDetectionState = 'Detecting Hand';
        } else if (coverage > 0.1) {
          objectDetectionState = 'Hand too far away/not centered';
        } else {
          objectDetectionState = 'Not Detecting Hand';
        }
      });
    });
  }

  @override
  void dispose() {
    _sensorStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(objectDetectionState),
    );
  }
}

/// Stateful widget to fetch and then display video content.
class _VideoPlayer extends StatefulWidget {
  const _VideoPlayer({super.key, required this.url});

  final String url;

  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<_VideoPlayer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url))
      ..initialize().then((_) {
        setState(() {
          _controller.setLooping(true).then((value) => _controller.play());
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _controller.value.isInitialized
          ? AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            )
          : Container(
              child: Text('fail'),
            ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
