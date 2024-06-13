import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:running_mate/src/theme/colors.dart';
import 'dart:convert';

class FlutterBlueApp extends StatefulWidget {
  @override
  _FlutterBlueAppState createState() => _FlutterBlueAppState();
}

class _FlutterBlueAppState extends State<FlutterBlueApp> {
  // FlutterBluePlus 인스턴스 생성
  FlutterBluePlus flutterBlue = FlutterBluePlus();
  // 검색된 BLE 장치 목록을 저장할 리스트
  List<ScanResult> scanResults = [];
  BluetoothDevice? connectedDevice;
  TextEditingController distanceController = TextEditingController();
  TextEditingController paceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initializeBluetooth(); // Bluetooth 설정 초기화
  }

  // Bluetooth 설정 초기화 및 지원 여부 확인
  void initializeBluetooth() async {
    try {
      // 로그 레벨 설정 (상세 로깅 활성화)
      await FlutterBluePlus.setLogLevel(LogLevel.verbose);

      // Bluetooth 기능 지원 여부 확인
      if (await FlutterBluePlus.isSupported == false) {
        print("블루투스가 지원되지 않습니다.");
        return;
      }
    } catch (e) {
      print("Error initializing Bluetooth: $e");
    }
  }

  void connectToDevice(BluetoothDevice device) async {
    try {
      await device.connect();
      setState(() {
        connectedDevice = device;
      });
      print("${device.platformName}에 연결되었습니다.");
    } catch (e) {
      print("Error connecting to device: $e");
    }
  }

  void sendRunningData() async {
    if (connectedDevice == null) return;

    var serviceUuid =
        Guid("0000ffe0-0000-1000-8000-00805f9b34fb"); // HM-10 기본 서비스 UUID
    var characteristicUuid =
        Guid("0000ffe1-0000-1000-8000-00805f9b34fb"); // HM-10 기본 특성 UUID

    List<BluetoothService> services = await connectedDevice!.discoverServices();
    var targetService =
        services.firstWhere((service) => service.uuid == serviceUuid);
    var targetCharacteristic = targetService.characteristics
        .firstWhere((char) => char.uuid == characteristicUuid);

    String distance = distanceController.text.toString();
    String pace = paceController.text.toString();

    print(("Distance: $distance, Pace: $pace"));
    print(("디스턴스가 잘 찍히나?"));

    await targetCharacteristic.write(utf8.encode(" $distance:$pace"));
  }

  void startScanAndConnect() async {
    // BLE 검색 시작
    FlutterBluePlus.startScan(
      timeout: Duration(seconds: 15),
    );

    // 검색된 디바이스 리스닝
    var subscription = FlutterBluePlus.scanResults.listen((results) {
      for (var result in results) {
        if (result.device.platformName == 'RunningMate') {
          // 'RunningMate' 기기 찾으면 연결
          connectToDevice(result.device);
          FlutterBluePlus.stopScan();
          // subscription.cancel();
          break;
        }
      }
    });

    // 검색 종료
    await Future.delayed(Duration(seconds: 15));
    FlutterBluePlus.stopScan();
    subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('블루투스 연결'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('블루투스'),
            Container(
              height: 65.0,
              margin: EdgeInsets.fromLTRB(0.0, 25.0, 2.0, 0.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: iris_100,
              ),
              child: TextButton(
                onPressed: startScanAndConnect,
                child: const Text(
                  '블루투스 연결하기',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'PretandardMedium',
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
            connectedDevice == null
                ? Container(
                    child: Column(
                    children: [
                      Text(
                        '러닝메이트에 연결할 수 없습니다.',
                        style: TextStyle(
                          color: gray3,
                          fontFamily: 'PretandardMedium',
                          fontSize: 18.0,
                        ),
                      ),
                      Image.asset(
                        'assets/images/disconnect.png',
                        height: 100.0,
                        fit: BoxFit.fill,
                      ),
                    ],
                  ))
                : Column(
                    children: [
                      Text(
                        '${connectedDevice!.platformName}에 연결되었습니다.',
                        style: TextStyle(
                          color: gray3,
                          fontFamily: 'PretandardMedium',
                          fontSize: 18.0,
                        ),
                      ),
                      Image.asset(
                        'assets/images/connect.png',
                        height: 100.0,
                        fit: BoxFit.fill,
                      ),
                      // TextField(
                      //   controller: distanceController,
                      //   decoration: InputDecoration(
                      //     labelText: '목표 설정하기',
                      //     labelStyle: TextStyle(
                      //       fontFamily: 'PretandardMedium',
                      //       color: gray4, // 레이블 텍스트 색상
                      //       fontSize: 20, // 레이블 텍스트 크기
                      //     ),
                      //     hintText: '목표를 선택해주세요',
                      //     hintStyle: TextStyle(
                      //       fontFamily: 'PretandardMedium',
                      //       color: gray4, // 레이블 텍스트 색상
                      //       fontSize: 14, // 레이블 텍스트 크기
                      //     ),
                      //     border: OutlineInputBorder(),
                      //     enabledBorder: OutlineInputBorder(
                      //       borderSide: BorderSide(
                      //         color: iris_100,
                      //       ),
                      //     ),
                      //     focusedBorder: OutlineInputBorder(
                      //       borderSide: BorderSide(
                      //         color: iris_80,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      TextField(
                        controller: paceController,
                        decoration: InputDecoration(
                          labelText: 'Enter pace',
                        ),
                      ),
                      ElevatedButton(
                        onPressed: sendRunningData,
                        child: Text('Send Data'),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
