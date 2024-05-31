import 'package:flutter/material.dart';
import 'package:running_mate/src/components/rive_image.dart';

class Check extends StatelessWidget {
  const Check({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [
                    0.1,
                    0.4,
                    0.6,
                  ],
                  colors: [
                    Color(0xff081c1d),
                    Color(0xff0b2a2d),
                    Color(0xff0d393f),
                  ]),
            ),
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _logo(),
                _text(),
              ],
            ))));
  }

  Widget _logo() {
    return RiveImage(imagePath: RiveAssetPath.check, width: 400, height: 400);
  }

  Widget _text() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      child: Text(
        'Please check your bluetooth status',
        style: TextStyle(
            fontFamily: 'Roboto',
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w100),
      ),
    );
  }
}
