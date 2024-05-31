import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:running_mate/src/theme/colors.dart';
import 'package:running_mate/src/screens/SetGoalScreen.dart';
import 'package:running_mate/src/screens/MyRecordScreen.dart';
import 'package:running_mate/src/screens/TimerPage.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

class PracticeScreen extends StatefulWidget {
  @override
  _PracticeScreenState createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  String userGoal = ''; // 마라톤 대회 변수
  String daysLeft = ''; // D-Day 변수

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final int price = 2000;

  bool showSpinner = false;

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
            Row(
              children: [
                Container(
                  height: 65.0,
                  width: 200.0,
                  margin: EdgeInsets.fromLTRB(
                      0.0, 25.0, 0.0, 0.0), // 위쪽에 25.0의 여백을 줍니다.
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(20.0), // 버튼의 모서리를 둥글게 만듭니다.
                    color: iris_100, // 버튼의 배경색을 흰색으로 설정합니다.
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TimerPage(),
                        ),
                      );
                    },
                    child: Text(
                      '연습 시작하기 >',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'PretandardMedium',
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20), // 여백 추가
                Expanded(
                  child: Container(
                    height: 65.0,
                    margin: EdgeInsets.fromLTRB(0.0, 25.0, 2.0, 0.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: iris_100,
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyRecordScreen(),
                          ),
                        );
                      },
                      child: Text(
                        '내 기록 >', // 버튼에 표시될 텍스트입니다.
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'PretandardMedium',
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('/running record/qLGojNsNczqZF0UI95Im/record')
                    .orderBy('date', descending: true) // 날짜 순으로 정렬
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final docs = snapshot.data!.docs;
                  //리스트뷰
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal, // 가로 방향 스크롤
                    child: Row(
                      children: docs.map((doc) {
                        return Container(
                          child: Column(
                            children: [
                              Text(
                                formatDate(doc['date']),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'PretandardMedium',
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                formatDistance(doc['distance']),
                                style: TextStyle(
                                  color: gray4,
                                  fontFamily: 'PretandardMedium',
                                  fontSize: 13.0,
                                ),
                              ),
                              Text(
                                formatTime(doc['start_time'], doc['end_time']),
                                style: TextStyle(
                                  color: gray4,
                                  fontFamily: 'PretandardMedium',
                                  fontSize: 13.0,
                                ),
                              ),
                            ],
                          ),
                          height: 85.0,
                          width: 85.0,
                          margin: EdgeInsets.fromLTRB(8.0, 25.0, 8.0, 0.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: iris_60,
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
            Container(
              height: 200,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('/running record/qLGojNsNczqZF0UI95Im/record')
                    .orderBy('date', descending: true) // 날짜 순으로 정렬
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();

                  List<charts.Series<PaceData, DateTime>> series = [
                    charts.Series<PaceData, DateTime>(
                      id: 'Running Pace',
                      colorFn: (_, __) =>
                          charts.MaterialPalette.blue.shadeDefault,
                      domainFn: (PaceData paces, _) => paces.date,
                      measureFn: (PaceData paces, _) =>
                          double.parse(paces.pace), // String을 double로 변환
                      data: snapshot.data!.docs
                          .map((doc) => PaceData(DateTime.parse(doc['date']),
                              doc['pace'])) // String으로 pace 필드를 받아옴
                          .toList(),
                    )
                  ];

                  // 동그라미 마크와 텍스트를 생성하는 함수
                  List<charts.Series> _createMarkerSeries(List<PaceData> data) {
                    return [
                      charts.Series<PaceData, DateTime>(
                        id: 'Pace Markers',
                        colorFn: (_, __) =>
                            charts.MaterialPalette.blue.shadeDefault,
                        domainFn: (PaceData paces, _) => paces.date,
                        measureFn: (PaceData paces, _) =>
                            double.parse(paces.pace),
                        data: data,
                        // 동그라미 마크 생성
                        radiusPxFn: (_, __) => 5, // 마크의 크기 설정
                        // 마크 위에 텍스트 생성
                        labelAccessorFn: (PaceData paces, _) =>
                            'Pace: ${paces.pace}',
                        // 텍스트 스타일 설정
                        insideLabelStyleAccessorFn: (PaceData paces, _) =>
                            charts.TextStyleSpec(fontSize: 12),
                      ),
                    ];
                  }

                  return charts.TimeSeriesChart(
                    series,
                    animate: true,
                    dateTimeFactory: const charts.LocalDateTimeFactory(),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

// Define the PaceData class
class PaceData {
  final DateTime date;
  final String pace;

  PaceData(this.date, this.pace);
}
