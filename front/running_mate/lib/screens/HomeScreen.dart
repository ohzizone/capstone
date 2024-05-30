import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:running_mate/screens/PracticeScreen.dart';
import 'package:running_mate/theme/colors.dart';
import 'package:running_mate/screens/SetGoalScreen.dart';
import 'package:running_mate/screens/LoginScreen.dart';
import 'package:running_mate/screens/FlutterBlueApp.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _authentication = FirebaseAuth.instance;
  User? loggedUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _authentication.currentUser;

      if (user != null) {
        loggedUser = user;
        print(loggedUser!.email);
      }
    } catch (e) {
      print(e);
    }
  }

  String userGoal = '마라톤 대회'; // 마라톤 대회 변수
  int daysLeft = 13; // D-Day 변수

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.fromLTRB(16.0, 71.0, 16.0, 0.0),
        child: Column(
          children: <Widget>[
            Container(
              height: 180.0,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: iris_80,
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.0, 20.0, 0.0, 0.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          userGoal,
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'PretandardMedium',
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '까지',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'PretandardMedium',
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'D - $daysLeft',
                          style: TextStyle(
                            color: pink,
                            fontFamily: 'PretandardMedium',
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          '조금만 더 힘내세요!',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'PretandardMedium',
                            fontSize: 18.0,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(182.0, 17.0, 0.0, 0.0),
                      child: Center(
                        child: FittedBox(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => SetGoalScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 0.0,
                              ),
                              textStyle: TextStyle(fontSize: 12.0),
                              backgroundColor: Colors.white,
                            ),
                            child: Text(
                              '새로운 D - Day 설정하기 >',
                              style: TextStyle(
                                color: gray4,
                                fontFamily: 'PretandardMedium',
                                fontSize: 12.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 25.0),
              width: double.infinity,
              height: 60.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0), // 버튼의 모서리를 둥글게 만듭니다.
                border: Border.all(color: Colors.grey), // 회색 선으로 버튼 테두리를 만듭니다.
                color: Colors.white, // 버튼의 배경색을 흰색으로 설정합니다.
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PracticeScreen(),
                    ),
                  );
                },
                child: Text(
                  '장거리 달리기 연습하기',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 25.0),
              width: double.infinity,
              height: 60.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0), // 버튼의 모서리를 둥글게 만듭니다.
                border: Border.all(color: Colors.grey), // 회색 선으로 버튼 테두리를 만듭니다.
                color: Colors.white, // 버튼의 배경색을 흰색으로 설정합니다.
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FlutterBlueApp(),
                    ),
                  );
                },
                child: Text(
                  '블루투스 연결하기',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
