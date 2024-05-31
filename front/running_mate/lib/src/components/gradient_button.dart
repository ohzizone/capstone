import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final double width;
  final double height;
  final List<Color> colors;
  final Widget? child;
  final void Function()? onPressed;
  const GradientButton(
      {super.key,
      required this.width,
      required this.height,
      this.child,
      this.onPressed,
      required this.colors});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
      child: Container(
        height: height,
        width: width,
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
            gradient: LinearGradient(
              colors: colors,
            )),
        child: InkWell(
          onTap: onPressed!,
          child: Center(
            child: child,
          ),
        ),
      ),
    );
  }
}
