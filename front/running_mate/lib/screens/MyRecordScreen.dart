import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:running_mate/models/MyRecord.dart';
import 'package:running_mate/theme/colors.dart';
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
  CalendarFormat _calendarFormat = CalendarFormat.month;

  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;
  // 기록 저장
  Map<DateTime, List<MyRecord>> records = {};

  Future<void> _loadRecords() async {
    User? user = FirebaseAuth.instance.currentUser;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    if (user != null) {
      String userId = user.uid; // 현재 사용자의 ID 가져오기
      // 파이어베이스에서 데이터를 읽어오는 비동기 함수
      QuerySnapshot querySnapshot = await _firestore
          .collection('running record')
          .doc(userId) // 사용자 ID를 사용하거나 원하는 사용자의 ID를 직접 입력하세요.
          .collection('record')
          .get();

      // 기록 저장
      Map<DateTime, List<MyRecord>> loadedRecords = {};

      // 가져온 각 문서를 반복하여 처리
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
    _loadRecords(); // 기록 불러오기
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('내 기록'),
      ),
      body: TableCalendar(
        focusedDay: DateTime.now(),
        firstDay: DateTime(2022, 1, 1),
        lastDay: DateTime(2029, 1, 31),
        locale: 'ko-KR',
        daysOfWeekHeight: 30,
        calendarFormat: _calendarFormat,
        selectedDayPredicate: (day) {
          // 선택된 날짜가 현재의 _selectedDay와 같은지 비교합니다.
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
    );
  }
}
