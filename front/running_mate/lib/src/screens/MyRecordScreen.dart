import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:running_mate/src/models/MyRecord.dart';
import 'package:running_mate/src/theme/colors.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyRecordScreen extends StatefulWidget {
  const MyRecordScreen({Key? key}) : super(key: key);

  @override
  _MyRecordScreenState createState() => _MyRecordScreenState();
}

class _MyRecordScreenState extends State<MyRecordScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.twoWeeks;

  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;

  Map<DateTime, List<MyRecord>> records = {};

  String formatDate(DateTime date) {
    // DateTime 객체를 원하는 형식의 문자열로 변환
    String formattedDate = '${date.month.toString().padLeft(2, '0')}/'
        '${date.day.toString().padLeft(2, '0')}';
    return formattedDate;
  }

  Future<void> _loadRecords() async {
    User? user = FirebaseAuth.instance.currentUser;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    if (user != null) {
      String userId = user.uid; // 현재 사용자의 ID 가져오기
      QuerySnapshot querySnapshot = await _firestore
          .collection('running record')
          .doc(userId)
          .collection('record')
          .get();

      Map<DateTime, List<MyRecord>> loadedRecords = {};

      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if (data.containsKey('date') && data['date'] != null) {
          // Timestamp를 DateTime으로 변환
          DateTime date = (data['date'] as Timestamp).toDate();

          // 날짜 부분만 추출하여 UTC 형식으로 변환
          DateTime dateOnly = DateTime.utc(date.year, date.month, date.day);
          MyRecord record = MyRecord(
            date: dateOnly,
            distance: data['distance'] as String,
            startTime: data['start_time'] as String,
            endTime: data['end_time'] as String,
            pace: data['pace'] as String,
          );
          if (loadedRecords[dateOnly] == null) {
            loadedRecords[dateOnly] = [];
          }
          loadedRecords[dateOnly]!.add(record);
        }
      });

      setState(() {
        records = loadedRecords;
        print('출력할게용!');
        print(records);
      });
    }
  }

  List<MyRecord> _getEventsForDay(DateTime day) {
    return records[day] ?? [];
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('ko-KR', null); // 날짜 형식 초기화
    _loadRecords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('내 기록'),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          TableCalendar(
            focusedDay: DateTime.now(),
            firstDay: DateTime(2022, 1, 1),
            lastDay: DateTime(2029, 1, 31),
            locale: 'ko-KR',
            daysOfWeekHeight: 30,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(selectedDay, day);
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onDaySelected: (_selectedDay, _focusedDay) {
              setState(() {
                selectedDay = _selectedDay;
                focusedDay = _focusedDay;
              });
            },
            availableCalendarFormats: const {
              CalendarFormat.month: 'Month',
              CalendarFormat.twoWeeks: '2 Weeks',
              CalendarFormat.week: 'Week',
            },
            headerStyle: HeaderStyle(
              titleCentered: true,
              titleTextStyle: TextStyle(
                color: gray4,
                fontFamily: 'PretandardMedium',
                fontSize: 20.0,
              ),
              headerPadding: EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
            ),
            calendarStyle: CalendarStyle(
              holidayTextStyle: TextStyle(
                color: gray4,
                fontFamily: 'PretandardMedium',
                fontSize: 15.0,
              ),
              defaultTextStyle: TextStyle(
                color: gray4,
                fontFamily: 'PretandardMedium',
                fontSize: 15.0,
              ),
              // today 표시 여부
              isTodayHighlighted: true,

              // today 글자 조정
              todayTextStyle: const TextStyle(
                color: const Color(0xFFFAFAFA),
                fontSize: 16.0,
              ),

              // today 모양 조정
              todayDecoration: const BoxDecoration(
                color: iris_80,
                shape: BoxShape.circle,
              ),

              selectedDecoration: const BoxDecoration(
                color: iris_100,
                shape: BoxShape.circle,
              ),

              // marker 모양 조정
              markerSizeScale: 0.1,
              markersAnchor: 3, // 마커 위치 조정

              markerDecoration: const BoxDecoration(
                color: pink,
                shape: BoxShape.circle,
              ),
            ),
            eventLoader: _getEventsForDay,
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: _buildEventList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEventList() {
    final events = selectedDay != null ? _getEventsForDay(selectedDay!) : [];
    return ListView(
      children: events.map((record) {
        return Card(
          color: iris_60,
          elevation: 2, // 그림자 높이
          margin:
              EdgeInsets.symmetric(vertical: 8, horizontal: 16), // 리스트 간격 조절
          child: ListTile(
            title: Text(
              '${formatDate(record.date)}',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'PretandardMedium',
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '시작 시간: ${record.startTime}',
                  style: TextStyle(
                    fontFamily: 'PretandardMedium',
                    fontSize: 14.0,
                  ),
                ),
                Text(
                  '종료 시간: ${record.endTime}',
                  style: TextStyle(
                    fontFamily: 'PretandardMedium',
                    fontSize: 14.0,
                  ),
                ),
                Text(
                  '페이스: ${record.pace}',
                  style: TextStyle(
                    fontFamily: 'PretandardMedium',
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
