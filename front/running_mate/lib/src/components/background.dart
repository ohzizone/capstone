import 'package:flutter/material.dart';

class BackGround extends StatelessWidget {
  final Widget? child;
  const BackGround({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: child,
    );
  }
}
