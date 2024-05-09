import 'package:flutter/material.dart';
import 'package:running_mate/theme/colors.dart';

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Second Page'),
        ),
        body: Center(
          child: ElevatedButton(
              child: Text('다시 첫 번째 페이지로'),
              onPressed: () {
                Navigator.pop(context);
              }),
        ));
  }
}
