import 'package:flutter/material.dart';

class Counter extends StatefulWidget {
  const Counter({Key? key}) : super(key: key);

  @override 
  _CounterState createState() => 
}

class _CounterState extends State<Counter> {
  final int price = 2000;

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  Stream<int> addStreamValue(){
    return Stream<int>.periodic(
      Duration(seconds: 1),
      (count) => price + count
    );
  }
}
