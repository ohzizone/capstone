import 'package:flutter/material.dart';
import 'package:running_mate/theme/colors.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';

class MyRecordScreen extends StatefulWidget {
  const MyRecordScreen({Key? key}) : super(key: key);

  @override
  _MyRecordScreenState createState() => _MyRecordScreenState();
}

class _MyRecordScreenState extends State<MyRecordScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('ko-KR', null).then((_) {
      setState(() {}); // 초기화가 완료되면 상태를 갱신하여 새로고침합니다.
    });
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
            headerPadding: EdgeInsets.fromLTRB(0, 8.0, 0, 8.0)),
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
          markerSizeScale: 10.0,
          markerDecoration: const BoxDecoration(
            color: iris_100,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
