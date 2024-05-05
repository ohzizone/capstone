import 'package:flutter/material.dart';
import 'package:running_mate/theme/colors.dart';
import 'package:running_mate/screens/SetGoalScreen.dart';

class PracticeScreen extends StatefulWidget {
  @override
  _PracticeScreenState createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
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
                            color: Colors.pink,
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
                      0.0, 25.0, 0.0, 0.0), // 위쪽에 20.0의 여백을 줍니다.
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
                          builder: (context) => SetGoalScreen(),
                        ),
                      );
                    },
                    child: Text(
                      '연습 시작하기 >', // 버튼에 표시될 텍스트입니다.
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'PretandardMedium',
                        fontSize: 18.0,
                      ), // 버튼 텍스트의 색상을 검정색으로 설정합니다.
                    ),
                  ),
                ),
                SizedBox(width: 20), // 여백 추가,
                Expanded(
                  child: Container(
                    height: 65.0,
                    margin: EdgeInsets.fromLTRB(0.0, 25.0, 2.0, 0.0),
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
                            builder: (context) => SetGoalScreen(),
                          ),
                        );
                      },
                      child: Text(
                        '내 기록 >', // 버튼에 표시될 텍스트입니다.
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'PretandardMedium',
                          fontSize: 18.0,
                        ), // 버튼 텍스트의 색상을 검정색으로 설정합니다.
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
