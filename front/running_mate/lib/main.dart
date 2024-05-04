import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:running_mate/screens/SplashScreen.dart';

// 앱의 시작점
// runApp 함수의 괄호 안에는 위젯이 들어간다.
void main() async {
  await Hive.initFlutter();
  // var box = await Hive.openBox('dataBox');
  runApp(MyApp());
}

// stl 입력
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '러닝 메이트',
      // home: SplashScreen(),
      home: SplashScreen(),
    );
  }
}
