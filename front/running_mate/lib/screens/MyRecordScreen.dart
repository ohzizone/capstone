import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class MyRecordScreen extends StatefulWidget {
  const MyRecordScreen({Key? key}) : super(key: key);

  @override
  _MyRecordScreenState createState() => _MyRecordScreenState();
}

class _MyRecordScreenState extends State<MyRecordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('내 기록'),
      ),
      body: TableCalendar(
        focusedDay: DateTime.now(),
        firstDay: DateTime(2024, 5, 1),
        lastDay: DateTime(2024, 5, 31),
        //locale: 'ko-KR',
        daysOfWeekHeight: 30,
        calendarBuilders: CalendarBuilders(
          dowBuilder: (context, day) {
            switch (day.weekday) {
              case 1:
                return Center(
                  child: Text('월'),
                );
              case 2:
                return Center(
                  child: Text('화'),
                );
              case 3:
                return Center(
                  child: Text('수'),
                );
              case 4:
                return Center(
                  child: Text('목'),
                );
              case 5:
                return Center(
                  child: Text('금'),
                );
              case 6:
                return Center(
                  child: Text('토'),
                );
              case 7:
                return Center(
                  child: Text(
                    '일',
                    style: TextStyle(color: Colors.red),
                  ),
                );
              default:
                return Center(
                  child: Text(''),
                );
            }
          },
        ),
      ),
    );
  }
}
