import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:running_mate/src/screens/PracticeScreen.dart';
import 'package:running_mate/src/theme/colors.dart';
import 'package:running_mate/src/screens/SetGoalScreen.dart';
import 'package:running_mate/src/screens/LoginScreen.dart';
import 'package:running_mate/src/screens/FlutterBlueApp.dart';
import 'package:running_mate/src/screens/BluetoothScreen.dart';
import 'package:running_mate/src/screens/BlutoothScreenTest.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

// Utility functions for formatting
String formatDate(String dateString) {
  List<String> parts = dateString.split('-');
  String month = parts[1];
  String day = parts[2];
  return '$month/$day';
}

String formatDistance(num) {
  return '${num}km';
}

String formatTime(String start_time, String end_time) {
  List<String> start = start_time.split(':');
  List<String> end = end_time.split(':');

  int startHour = int.parse(start[0]);
  int startMin = int.parse(start[1]);
  int startSec = int.parse(start[2]);

  int endHour = int.parse(end[0]);
  int endMin = int.parse(end[1]);
  int endSec = int.parse(end[2]);

  int hourDiff = endHour - startHour;
  int minDiff = endMin - startMin;
  int secDiff = endSec - startSec;

  if (secDiff < 0) {
    secDiff += 60;
    minDiff -= 1;
  }

  if (minDiff < 0) {
    minDiff += 60;
    hourDiff -= 1;
  }

  String result = '';
  if (hourDiff > 0) {
    result += '$hourDiff h ';
  }
  if (minDiff > 0) {
    result += '$minDiff m ';
  }
  result += '$secDiff s';

  return result.trim();
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String userGoal = ''; // 마라톤 대회 변수
  String daysLeft = ''; // D-Day 변수

  String calculateDaysDifference(String goalDate) {
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');

    DateTime currentDate = DateTime.now();
    String currentDateString = dateFormat.format(currentDate);

    DateTime targetDate = dateFormat.parse(goalDate);
    currentDate = dateFormat.parse(currentDateString);

    Duration difference = targetDate.difference(currentDate);
    int daysDifference = difference.inDays;

    print('daysDifference');
    print(daysDifference);

    if (daysDifference == 0) {
      return 'D - day';
    } else if (daysDifference < 0) {
      return 'D + ${(-daysDifference).toString()}';
    } else {
      return 'D - ${daysDifference.toString()}';
    }
  }

  void _loadGoal() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentReference goalRef = _firestore
          .collection('goals')
          .doc(user.uid)
          .collection('goal')
          .doc('rVyj0NS9aGSYscPMxVjC');
      DocumentSnapshot goalSnapshot = await goalRef.get();
      if (goalSnapshot.exists) {
        setState(() {
          userGoal = goalSnapshot['goal'];

          //_selectedDate = (goalSnapshot['date'] as Timestamp).toDate();
          daysLeft = goalSnapshot['date'];
          daysLeft = calculateDaysDifference(daysLeft);
        });
      }
    }
  }

  void initState() {
    super.initState();
    _loadGoal();
  }

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
                          '$daysLeft',
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
                            fontSize: 15.0,
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
                                  builder: (context) => SetGoalScreen(),
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
                      //builder: (_) => BluetoothScreen(),
                      builder: (_) => BluetoothScreen(),
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
