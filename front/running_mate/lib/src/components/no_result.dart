import 'package:flutter/material.dart';
import 'package:running_mate/src/res/rive_path.dart';
import 'package:rive/rive.dart';

class NoResult extends StatelessWidget {
  final double width;
  final double height;
  const NoResult({super.key, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              width: width,
              height: height,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: RiveAnimation.asset(RiveAssetPath.noResult),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'No Result Found',
              style: TextStyle(
                  fontFamily: 'Roboto', color: Colors.white, fontSize: 24),
            ),
          ),
        ],
      ),
    );
  }
}
