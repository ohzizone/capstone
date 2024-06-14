import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:running_mate/src/theme/colors.dart';
import 'package:running_mate/src/services/location.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';

class TimerScreen extends StatefulWidget {
  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  @override
  void initState() {
    super.initState();
    getLocationData();
  }

  String distance = "0.0";
  String startTime = "";
  String time = "0";
  String endTime = "05:10:27";
  bool isRunning = false;
  Timer? timer;
  Timer? locationTimer;
  int seconds = 0;
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  Position? _startPosition;
  Position? _currentPosition;
  StreamSubscription<Position>? _positionStreamSubscription;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Position? _lastPosition;
  double _totalDistance = 0.0;

  void updateGoal(String newDistance, String newTime) {
    if (mounted) {
      setState(() {
        distance = newDistance;
        time = newTime;
      });
    }
  }

  void getLocationData() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    _lastPosition = await Geolocator.getCurrentPosition();
    setState(() {});
  }

  void _saveRecord() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentReference recordRef = _firestore
          .collection('running record')
          .doc(user.uid)
          .collection('record')
          .doc();
      await recordRef.set({
        'date': dateFormat.format(DateTime.now()),
        'distance': distance,
        'start_time': startTime,
        'end_time': endTime,
        'pace': '6.48'
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('기록이 저장되었습니다.')),
        );
      }
    }
  }

  void startTimer() {
    // 현재 시간으로 startTime 업데이트
    startTime = DateFormat('HH:mm:ss').format(DateTime.now());

    _lastPosition = _currentPosition;

    locationTimer = Timer.periodic(Duration(seconds: 5), (locationTimer) async {
      Position newPosition = await Geolocator.getCurrentPosition();
      if (_lastPosition != null) {
        double distanceInMeters = Geolocator.distanceBetween(
          _lastPosition!.latitude,
          _lastPosition!.longitude,
          newPosition.latitude,
          newPosition.longitude,
        );

        _totalDistance += distanceInMeters;
        print("이동 거리: ${_totalDistance.toStringAsFixed(1)} m");

        setState(() {
          distance = (_totalDistance / 1000).toStringAsFixed(1); // km로 변환
        });

        _lastPosition = newPosition;
      }
    });

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          seconds++;
        });
      }
    });
    if (mounted) {
      setState(() {
        isRunning = true;
      });
    }
  }

  void stopTimer() {
    //_saveRecord();
    timer?.cancel();
    locationTimer?.cancel();
    if (mounted) {
      setState(() {
        isRunning = false;
      });
    }
  }

  void resetTimer() {
    timer?.cancel();
    locationTimer?.cancel();
    if (mounted) {
      setState(() {
        seconds = 0;
        _totalDistance = 0.0;
        distance = "0.0";
        isRunning = false;
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    locationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          '기록 측정하기',
          style: TextStyle(
            color: gray4,
            fontFamily: 'PretandardMedium',
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          TimerRecords(distance: distance, time: time, updateGoal: updateGoal),
          Expanded(child: TimerDisplay(seconds: seconds, distance: distance)),
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
      margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
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
                TextSpan(
                  text: '${distance}km ${time}초',
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
  final String distance;
  const TimerDisplay({Key? key, required this.seconds, required this.distance})
      : super(key: key);

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
            '$distance Km',
            style: const TextStyle(
                color: gray4,
                fontFamily: 'PretandardMedium',
                fontSize: 20.0,
                fontWeight: FontWeight.bold),
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
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 35),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (!isRunning)
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 40),
              child: ElevatedButton(
                onPressed: startTimer,
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
              ),
            )
          else ...[
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 40),
              child: ElevatedButton(
                onPressed: stopTimer,
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
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 40),
              child: ElevatedButton(
                onPressed: resetTimer,
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
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("목표 설정하기",
                      style: TextStyle(
                          fontFamily: 'PretandardMedium',
                          color: gray4,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  TextField(
                    onChanged: (value) => localDistance = value,
                    decoration: InputDecoration(
                      labelText: "거리 (m)",
                      labelStyle: TextStyle(
                        fontFamily: 'PretandardMedium',
                        color: gray4,
                        fontSize: 20,
                      ),
                      hintText: '목표 거리를 입력해주세요',
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: iris_100,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: iris_80,
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    onChanged: (value) => localTime = value,
                    decoration: InputDecoration(
                      labelText: "시간 (초)",
                      hintText: '목표 시간을 입력해주세요',
                      labelStyle: TextStyle(
                        fontFamily: 'PretandardMedium',
                        color: gray4,
                        fontSize: 20,
                      ),
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: iris_100,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: iris_80,
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      updateGoal(localDistance, localTime);
                    },
                    child: const Text(
                      "완료",
                      style: TextStyle(
                        fontFamily: 'PretandardMedium',
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: iris_100,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
