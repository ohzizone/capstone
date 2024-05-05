import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:running_mate/theme/colors.dart';
import 'package:running_mate/screens/HomeScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  List<SystemUiOverlay>? _previousSystemOverlays; // 이전 시스템 오버레이 스타일을 저장할 변수

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive); // 전체화면 모드로 설정

    // 5초 후에 FirstPage로 이동
    Future.delayed(Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: iris_80,
      body: Padding(
        padding: EdgeInsets.fromLTRB(30.0, 222.0, 0.0, 0.0),
        child: Center(
          child: Column(
            children: <Widget>[
              Image.asset(
                'assets/images/splash_logo.png',
                height: 180.0,
                fit: BoxFit.fill,
              ),
              Text(
                '러닝 메이트',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'PretandardBold',
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Pace maker',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'PretandardMedium',
                  fontSize: 20.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
