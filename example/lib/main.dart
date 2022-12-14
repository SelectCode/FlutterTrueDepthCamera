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

  @override
  void initState() {
    super.initState();
    _controller = CvCamera.getCameraController();
  }

  @override
  void dispose() {
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
          child: Builder(
            builder: (context) {
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
                              height: 200,
                              child: Image.file(File(result.path)),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.flip_camera_ios),
                        onPressed: () async {
                          await _controller.flipCamera();
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
            }
          ),
        ),
      ),
    );
  }
}
