import 'package:flutter/material.dart';
import 'package:running_mate/screens/LoginScreen.dart';
import 'package:running_mate/screens/SplashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';

//
// 앱의 시작점
// runApp 함수의 괄호 안에는 위젯이 들어간다.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await initializeDateFormatting();
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
