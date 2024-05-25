import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:running_mate/theme/colors.dart';
import 'package:running_mate/service/practiceService.dart';

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

class Counter extends StatefulWidget {
  const Counter({Key? key}) : super(key: key);

  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  final int price = 2000;

  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stream builder'),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('/running record/qLGojNsNczqZF0UI95Im/record')
              .snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            final docs = snapshot.data!.docs;
            return SingleChildScrollView(
              // SingleChildScrollView를 사용하여 Row의 내용이 화면을 벗어날 때 스크롤 가능하도록 합니다.
              scrollDirection: Axis.horizontal, // 가로 방향 스크롤
              child: Row(
                children: docs.map((doc) {
                  return Container(
                    child: Column(children: [
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
                          //fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        formatTime(doc['start_time'], doc['end_time']),
                        style: TextStyle(
                          color: gray4,
                          fontFamily: 'PretandardMedium',
                          fontSize: 13.0,
                          //fontWeight: FontWeight.bold,
                        ),
                      ),
                    ]),
                    height: 85.0,
                    width: 85.0,
                    margin: EdgeInsets.fromLTRB(
                        8.0, 25.0, 8.0, 25.0), // 위쪽에 20.0의 여백을 줍니다.
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(5.0), // 버튼의 모서리를 둥글게 만듭니다.
                      color: iris_60,
                      //padding: EdgeInsets.all(8.0),
                    ),
                  );
                }).toList(),
              ),
            );
          }),
    );
  }

  Stream<int> addStreamValue() {
    return Stream<int>.periodic(Duration(seconds: 1), (count) => price + count);
  }
}
