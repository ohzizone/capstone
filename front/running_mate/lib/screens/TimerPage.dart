import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:running_mate/theme/colors.dart';

class TimerPage extends StatefulWidget {
  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  String distance = "0";
  String time = "0";
  bool isRunning = false;
  Timer? timer;
  int seconds = 0;

  void updateGoal(String newDistance, String newTime) {
    setState(() {
      distance = newDistance;
      time = newTime;
    });
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        seconds++;
      });
    });
    setState(() {
      isRunning = true;
    });
  }

  void stopTimer() {
    timer?.cancel();
    setState(() {
      isRunning = false;
    });
  }

  void resetTimer() {
    timer?.cancel();
    setState(() {
      seconds = 0;
      isRunning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      //appBar: CustomAppBar(),
      body: Column(
        children: <Widget>[
          TimerRecords(distance: distance, time: time, updateGoal: updateGoal),
          Expanded(child: TimerDisplay(seconds: seconds)),
          TimerControls(
              isRunning: isRunning,
              startTimer: startTimer,
              stopTimer: stopTimer,
              resetTimer: resetTimer),
        ],
      ),
    );
  }
}

// class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       backgroundColor: Colors.white,
//       elevation: 0,
//       leading: const Icon(Icons.arrow_back, color: Colors.black),
//       actions: const [Icon(Icons.more_vert, color: Colors.black)],
//     );
//   }

//   @override
//   Size get preferredSize => Size.fromHeight(kToolbarHeight);
// }

class TimerRecords extends StatelessWidget {
  final String distance;
  final String time;
  final Function(String, String) updateGoal;

  const TimerRecords(
      {Key? key,
      required this.distance,
      required this.time,
      required this.updateGoal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(20, 50, 20, 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: iris_80,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('현재 목표',
              style: TextStyle(
                  fontFamily: 'PretandardMedium',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          const SizedBox(height: 10),
          RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 16, color: Colors.white),
              children: <TextSpan>[
                //const TextSpan(text: '현재 목표: '),
                TextSpan(
                  text: '${distance}m ${time}초',
                  style: const TextStyle(
                      color: gray4,
                      fontFamily: 'PretandardMedium',
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                ),
                const TextSpan(
                  text: ' 안에 달리기',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'PretandardMedium',
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SetGoalButton(updateGoal: updateGoal),
        ],
      ),
    );
  }
}

class TimerDisplay extends StatelessWidget {
  final int seconds;
  const TimerDisplay({Key? key, required this.seconds}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int secs = seconds % 60;
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                  color: Color.fromARGB(255, 229, 224, 224), width: 3),
            ),
          ),
          Text(
              '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(220, 153, 146, 146))),
        ],
      ),
    );
  }
}

class TimerControls extends StatelessWidget {
  final bool isRunning;
  // 함수 타입을 'void Function()'으로 변경
  final void Function() startTimer;
  final void Function() stopTimer;
  final void Function() resetTimer;

  TimerControls(
      {Key? key,
      required this.isRunning,
      required this.startTimer,
      required this.stopTimer,
      required this.resetTimer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (!isRunning)
            ElevatedButton(
              onPressed: startTimer, // 함수가 이제 적절한 타입으로 전달됩니다.
              child: const Text(
                '시작',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'PretandardMedium',
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: iris_100,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              ),
            )
          else ...[
            ElevatedButton(
              onPressed: stopTimer, // 함수가 이제 적절한 타입으로 전달됩니다.
              child: const Text(
                '중지',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'PretandardMedium',
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: iris_100,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              ),
            ),
            ElevatedButton(
              onPressed: resetTimer, // 함수가 이제 적절한 타입으로 전달됩니다.
              child: const Text(
                '취소',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'PretandardMedium',
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: iris_100,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              ),
            ),
          ]
        ],
      ),
    );
  }
}

class SetGoalButton extends StatelessWidget {
  final Function(String, String) updateGoal;

  const SetGoalButton({Key? key, required this.updateGoal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OutlinedButton(
          onPressed: () {
            _showGoalDialog(context);
          },
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            side: BorderSide.none,
          ),
          child: const Text(
            '새로운 목표 설정하기 >',
            style: TextStyle(
              color: gray4,
              fontFamily: 'PretandardMedium',
              fontSize: 15.0,
            ),
          ),
        ),
      ],
    );
  }

  void _showGoalDialog(BuildContext context) {
    String localDistance = "0";
    String localTime = "0";
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("목표 설정하기",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                TextField(
                  onChanged: (value) => localDistance = value,
                  decoration: const InputDecoration(
                    labelText: "거리 (m)",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                TextField(
                  onChanged: (value) => localTime = value,
                  decoration: const InputDecoration(
                    labelText: "시간 (초)",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    updateGoal(localDistance, localTime);
                  },
                  child: const Text("완료"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
