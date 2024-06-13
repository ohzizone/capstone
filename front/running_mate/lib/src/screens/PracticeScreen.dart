import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:running_mate/src/theme/colors.dart';
import 'package:running_mate/src/screens/SetGoalScreen.dart';
import 'package:running_mate/src/screens/MyRecordScreen.dart';
import 'package:running_mate/src/screens/TimerPage.dart';
import 'package:running_mate/src/screens/TimerScreen.dart';

// Utility functions for formatting
String formatDate(Timestamp timestamp) {
  DateTime date = timestamp.toDate();
  return DateFormat('MM/dd').format(date);
}

String formatDistance(String metersString) {
  double meters = double.tryParse(metersString) ?? 0.0;
  double kilometers = meters / 1000.0;
  return '${kilometers.toStringAsFixed(1)}km';
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
  String userId = ''; // D-Day 변수
  List<PaceData> paceData = [];

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
      userId = user.uid;
      DocumentReference goalRef = _firestore
          .collection('goals')
          .doc(user.uid)
          .collection('goal')
          .doc('rVyj0NS9aGSYscPMxVjC');
      DocumentSnapshot goalSnapshot = await goalRef.get();
      if (goalSnapshot.exists) {
        setState(() {
          userGoal = goalSnapshot['goal'];
          daysLeft = calculateDaysDifference(goalSnapshot['date']);
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadGoal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(16.0, 30.0, 16.0, 0.0),
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
                  margin: EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: iris_100,
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TimerPage(), // 페이지 이동 TimerPage : 지도 , TimerScreen : 지도 X
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
                SizedBox(width: 20),
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
                        '내 기록 >',
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
                    .collection('running record')
                    .doc(userId)
                    .collection('record')
                    .orderBy('date', descending: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  paceData = [];
                  final docs = snapshot.data!.docs;

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
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
            SizedBox(
              height: 20.0,
            ),
            Container(
              height: 200,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('running record')
                    .doc(userId)
                    .collection('record')
                    .orderBy('date', descending: true)
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
                  //List<PaceData> paceData = [];

                  for (var doc in docs) {
                    if (paceData.length <= 5) {
                      final DateTime date = (doc['date'] as Timestamp).toDate();
                      final double pace = double.parse(doc['pace']);

                      final sameDateGroup =
                          paceData.where((data) => data.date == date);

                      if (sameDateGroup.isEmpty) {
                        paceData.add(PaceData(date, pace));
                      } else {
                        final lowestPaceData = sameDateGroup
                            .reduce((a, b) => a.pace < b.pace ? a : b);

                        if (pace < lowestPaceData.pace) {
                          paceData.remove(lowestPaceData);
                          paceData.add(PaceData(date, pace));
                        }
                      }
                    }
                  }

                  paceData.sort((a, b) => a.date.compareTo(b.date));

                  return Padding(
                    padding: const EdgeInsets.only(
                      right: 15,
                      left: 0,
                      top: 0,
                      bottom: 0,
                    ),
                    child: LineChart(
                      buildChartData(paceData),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomTitleWidget(double value, TitleMeta meta) {
    final dateText = (value.toInt() >= 0 && value.toInt() < paceData.length)
        ? DateFormat('MM/dd').format(paceData[value.toInt()].date)
        : '';

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        dateText,
        style: TextStyle(
          //fontWeight: FontWeight.bold,
          fontFamily: 'PretandardMedium',
          color: gray4,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget leftTitleWidget(double value, TitleMeta meta) {
    int pace = value.toInt();

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        pace.toString(),
        style: TextStyle(
          //fontWeight: FontWeight.bold,
          fontFamily: 'PretandardMedium',
          color: gray4,
          fontSize: 13,
        ),
      ),
    );
  }

  LineChartData buildChartData(List<PaceData> paceData) {
    List<FlSpot> spots = [];

    for (int i = 0; i < paceData.length; i++) {
      spots.add(FlSpot(i.toDouble(), paceData[i].pace));
    }

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 2,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: gray2,
            strokeWidth: 1,
          );
        },
        // getDrawingVerticalLine: (value) {
        //   return const FlLine(
        //     color: gray2,
        //     strokeWidth: 1,
        //   );
        // },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
            reservedSize: 42,
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidget,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 2,
            reservedSize: 37,
            getTitlesWidget: leftTitleWidget,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: gray2),
      ),
      minX: 0,
      maxX: (paceData.length - 1).toDouble(),
      minY: 0,
      maxY: paceData
              .map((data) => data.pace)
              .reduce((a, b) => a > b ? a : b)
              .ceilToDouble() +
          1,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: false,
          gradient: LinearGradient(
            colors: [iris_100, iris_80],
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [iris_100.withOpacity(0.3), iris_60.withOpacity(0.3)],
            ),
          ),
        ),
      ],
    );
  }
}

// Define the PaceData class
class PaceData {
  final DateTime date;
  final double pace;

  PaceData(this.date, this.pace);
}
