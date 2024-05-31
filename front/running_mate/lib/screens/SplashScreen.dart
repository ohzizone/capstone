import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:running_mate/theme/colors.dart';
import 'package:running_mate/screens/HomeScreen.dart';
import 'package:running_mate/screens/PracticeScreen.dart';
import 'package:running_mate/screens/LoginScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _checkLoginStatus() async {
    await Future.delayed(Duration(seconds: 5)); // 5초 대기
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // 로그인된 상태
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    } else {
      // 로그인되지 않은 상태
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive); // 전체화면 모드로 설정
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
