import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:running_mate/theme/colors.dart';
import 'package:running_mate/screens/SecondPage.dart';

class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('First Page'),
        ),
        body: Center(
          child: ElevatedButton(
              child: Text('Go To the Second page'),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SecondPage()));
              }),
        ));
  }
}
