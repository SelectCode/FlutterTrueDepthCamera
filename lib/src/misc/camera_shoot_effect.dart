import 'package:flutter/material.dart';

class CameraShootEffectController extends ChangeNotifier {
  void play() {
    notifyListeners();
  }
}

class CameraShootEffect extends StatefulWidget {
  const CameraShootEffect({Key? key, required this.controller})
      : super(key: key);

  final CameraShootEffectController controller;

  @override
  State<CameraShootEffect> createState() => _CameraShootEffectState();
}

class _CameraShootEffectState extends State<CameraShootEffect> {
  Color foregroundColor = Colors.transparent;

  static const Duration _duration = Duration(milliseconds: 200);

  void play() {
    setState(() {
      foregroundColor = Colors.black.withOpacity(0.6);
    });
    Future.delayed(_duration, () {
      if (mounted) {
        setState(() {
          foregroundColor = Colors.transparent;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(play);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: _duration,
      color: foregroundColor,
    );
  }
}
