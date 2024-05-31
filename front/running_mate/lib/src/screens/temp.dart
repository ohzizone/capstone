import 'package:flutter/material.dart';
import 'package:running_mate/src/theme/colors.dart';

import 'package:running_mate/src/screens/SetGoalScreen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.fromLTRB(16.0, 71.0, 16.0, 0.0),
        child: Column(
          children: <Widget>[
            Container(
                height: 180.0, // 높이를 100px로 고정
                width: double
                    .infinity, // 너비를 부모 위젯의 크기에 맞추기 위해 double.infinity로 설정
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: iris_80,
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(180.0, 110.0, 0.0, 0.0),
                  child: Center(
                    child: FittedBox(
                      // FittedBox를 사용하여 버튼 크기 조정
                      child: ElevatedButton(
                        onPressed: () {
                          // 버튼을 눌렀을 때 수행할 동작 정의
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SetGoalScreen()));
                        },
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 0.0),
                            textStyle: TextStyle(fontSize: 12.0),
                            backgroundColor: Colors.white),
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
                )),
          ],
        ),
      ),
    );
  }
}
