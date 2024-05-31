import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class RiveImage extends StatelessWidget {
  final String imagePath;
  final double width;
  final double height;
  const RiveImage(
      {super.key,
      required this.imagePath,
      required this.width,
      required this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 300,
      child: RiveAnimation.asset(
        imagePath,
      ),
    );
  }
}

class RiveAssetPath {
  static String get onboard => 'assets/rives/bluetooth_onboard.riv';
  static String get search => 'assets/rives/circular_progress_indicator.riv';
  static String get noResult => 'assets/rives/search.riv';
  static String get connect => 'assets/rives/connect.riv';
  static String get disconnect => 'assets/rives/disconnect.riv';
  static String get check => 'assets/rives/bluetooth_disconnect.riv';
  static String get ledOn => 'assets/rives/on.riv';
  static String get ledOff => 'assets/rives/off.riv';
}
