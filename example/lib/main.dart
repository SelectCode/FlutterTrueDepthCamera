import 'dart:async';
import 'dart:io';

import 'package:cv_camera/cv_camera.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    _controller = CvCamera.getCameraController();
    setUpStream();
  }

  void setUpStream() async {
    final stream = await _controller.startImageStream();
    _cameraImageStream = stream.listen((image) {
      // print(image.width);
    });
  }

  @override
  void dispose() {
    _cameraImageStream.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
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
                        final result = await _controller.takePicture();
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => SizedBox(
                            height: MediaQuery.of(context).size.height * 0.7,
                            child: Image.file(File(result.path)),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.flip_camera_ios),
                      onPressed: () async {
                      },
                    ),
                  ],
                ),
                Expanded(
                  child: CameraPreview(
                    controller: _controller,
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
