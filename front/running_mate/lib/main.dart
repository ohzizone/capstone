import 'package:flutter/material.dart';
import 'package:running_mate/screens/LoginScreen.dart';
import 'package:running_mate/screens/SplashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:running_mate/screens/TimerPage.dart'; //

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NaverMapSdk.instance.initialize(
    clientId: '019aslid8u', // 네이버 맵 SDK 클라이언트 ID
    onAuthFailed: (error) => print('네이버 맵 인증 실패: $error'),
  );

  await initializeDateFormatting();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '러닝 메이트',
      home: SplashScreen(),
    );
  }
}
