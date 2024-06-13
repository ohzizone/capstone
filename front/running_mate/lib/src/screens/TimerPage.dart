import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:running_mate/src/theme/colors.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class TimerPage extends StatefulWidget {
  @override
  _TimerPageState createState() => _TimerPageState();
}

//
class _TimerPageState extends State<TimerPage>
    with SingleTickerProviderStateMixin {
  String distance = "0";
  String time = "0";
  bool isRunning = false;
  bool hasStarted = false; // 처음에는 false
  bool showMap = false; // 네이버 지도를 표시할지 여부
  Timer? timer;
  int seconds = 0;

  late AnimationController _animationController;
  final Completer<NaverMapController> mapControllerCompleter = Completer();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(minutes: 1), // 애니메이션 전체 시간을 1분으로 설정
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    timer?.cancel();
    super.dispose();
  }

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
      hasStarted = true; // 타이머가 시작되면 true로 설정
      showMap = false;
      _animationController.repeat(); // 애니메이션 반복 시작
    });
  }

  void stopTimer() {
    timer?.cancel();
    setState(() {
      isRunning = false;
      showMap = true; // '중단' 버튼을 누르면 네이버 지도를 표시
      _animationController.stop(); // 애니메이션 중지
    });
  }

  void resetTimer() {
    timer?.cancel();
    setState(() {
      seconds = 0;
      isRunning = false;
      showMap = false;
      _animationController.reset(); // 애니메이션 리셋
    });
  }

  String _formatTime(int seconds) {
    final int minutes = seconds ~/ 60;
    final int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Widget _buildMapWidget() => SizedBox(
        height: 200, // 원하는 높이로 조정
        width: double.infinity,
        child: NaverMap(
          options: const NaverMapViewOptions(
            indoorEnable: true, // 실내 맵 사용 가능 여부 설정
            locationButtonEnable: false, // 위치 버튼 표시 여부 설정
            consumeSymbolTapEvents: false, // 심볼 탭 이벤트 소비 여부 설정
          ),
          onMapReady: (controller) async {
            // 지도 준비 완료 시 호출되는 콜백 함수
            mapControllerCompleter
                .complete(controller); // Completer에 지도 컨트롤러 완료 신호 전송
            debugPrint("onMapReady");
          },
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          TimerRecords(
            distance: distance,
            time: time,
            updateGoal: updateGoal,
            showMap: showMap,
            buildMapWidget: _buildMapWidget,
          ),
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 20),
                    const Column(
                      children: [
                        Text('- -',
                            style: TextStyle(
                              fontSize: 30,
                              fontFamily: 'PretandardMedium',
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            )),
                        Text(
                          'BPM',
                          style: TextStyle(
                            fontFamily: 'PretandardMedium',
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const Column(
                      children: [
                        Text('0\'0\'\'',
                            style: TextStyle(
                              fontSize: 30,
                              fontFamily: 'PretandardMedium',
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            )),
                        Text(
                          '평균 페이스',
                          style: TextStyle(
                            fontFamily: 'PretandardMedium',
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(_formatTime(seconds),
                            style: const TextStyle(
                              fontSize: 30,
                              fontFamily: 'PretandardMedium',
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            )),
                        const Text(
                          '시간',
                          style: TextStyle(
                            fontFamily: 'PretandardMedium',
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40.0), // 원하는 만큼 아래로 내리기
                  child: CircleTimer(
                    animation: _animationController,
                    strokeWidth: 2.0, // 두께 조절
                    handleRadius: 10.0, // 포인트 원의 반지름
                    circleRadius: 150.0, // 원의 반지름을 조정
                    child: Container(
                      width: 300, // 원의 넓이에 맞춰 조정
                      height: 300, // 원의 넓이에 맞춰 조정
                      alignment: Alignment.center,
                      child: Text(
                        '${double.tryParse(distance)?.toStringAsFixed(1) ?? "0"} km',
                        style: const TextStyle(
                          fontSize: 30,
                          fontFamily: 'PretandardMedium',
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          TimerControls(
            isRunning: isRunning,
            hasStarted: hasStarted, // 전달
            startTimer: startTimer,
            stopTimer: stopTimer,
            resetTimer: resetTimer,
          ),
        ],
      ),
    );
  }
}

class TimerRecords extends StatelessWidget {
  final String distance;
  final String time;
  final Function(String, String) updateGoal;
  final bool showMap; // 네이버 지도를 표시할지 여부
  final Widget Function() buildMapWidget; // 지도를 생성하는 함수

  const TimerRecords({
    Key? key,
    required this.distance,
    required this.time,
    required this.updateGoal,
    required this.showMap,
    required this.buildMapWidget,
  }) : super(key: key);

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
          if (showMap) buildMapWidget(), // 네이버 지도를 표시
          if (!showMap) ...[
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
        ],
      ),
    );
  }
}

class TimerControls extends StatelessWidget {
  final bool isRunning;
  final bool hasStarted;
  final void Function() startTimer;
  final void Function() stopTimer;
  final void Function() resetTimer;

  TimerControls({
    Key? key,
    required this.isRunning,
    required this.hasStarted,
    required this.startTimer,
    required this.stopTimer,
    required this.resetTimer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20), // 원래의 패딩 값 유지
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (isRunning) ...[
            ElevatedButton(
              onPressed: stopTimer,
              child: const Text(
                '중단',
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
          ] else ...[
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 20.0), // 시작 버튼을 위로 이동시킬 만큼의 여백 추가
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
            ),
            if (hasStarted)
              ElevatedButton(
                onPressed: resetTimer,
                child: const Text(
                  '기록',
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
          ],
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

class CircleTimerPainter extends CustomPainter {
  final Animation<double> animation;
  final double strokeWidth;
  final double handleRadius;
  final double circleRadius;

  CircleTimerPainter(
    this.animation, {
    this.strokeWidth = 4.0,
    this.handleRadius = 10.0,
    this.circleRadius = 100.0,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    double radius = circleRadius - strokeWidth / 2;
    double angle = 2 * pi * animation.value - pi / 2;

    Paint paint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(Offset(size.width / 2, size.height / 2), radius, paint);

    Paint handlePaint = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.fill;

    double handleX = size.width / 2 + radius * cos(angle);
    double handleY = size.height / 2 + radius * sin(angle);

    canvas.drawCircle(Offset(handleX, handleY), handleRadius, handlePaint);
  }

  @override
  bool shouldRepaint(CircleTimerPainter oldDelegate) {
    return oldDelegate.animation != animation ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.handleRadius != handleRadius ||
        oldDelegate.circleRadius != circleRadius;
  }
}

class CircleTimer extends StatelessWidget {
  final Animation<double> animation;
  final double strokeWidth;
  final double handleRadius;
  final double circleRadius;
  final Widget child;

  CircleTimer({
    required this.animation,
    this.strokeWidth = 4.0,
    this.handleRadius = 10.0,
    this.circleRadius = 100.0,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CircleTimerPainter(
        animation,
        strokeWidth: strokeWidth,
        handleRadius: handleRadius,
        circleRadius: circleRadius,
      ),
      child: child,
    );
  }
}
