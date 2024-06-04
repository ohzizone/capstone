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
        print("Bluetooth not supported by this device");
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
    } catch (e) {
      print("Error connecting to device: $e");
    }
  }

  void sendRunningData() async {
    if (connectedDevice == null) return;

    // 서비스와 특성을 찾는 로직을 추가해야 합니다.
    // 여기서는 예제로 임의의 UUID를 사용합니다.
    var serviceUuid = Guid("YOUR_SERVICE_UUID");
    var characteristicUuid = Guid("YOUR_CHARACTERISTIC_UUID");

    List<BluetoothService> services = await connectedDevice!.discoverServices();
    var targetService =
        services.firstWhere((service) => service.uuid == serviceUuid);
    var targetCharacteristic = targetService.characteristics
        .firstWhere((char) => char.uuid == characteristicUuid);

    String distance = distanceController.text;
    String pace = paceController.text;

    await targetCharacteristic
        .write(utf8.encode("Distance: $distance, Pace: $pace"));
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
            Text('Flutter Blue Plus Example'),
            Container(
              height: 65.0,
              margin: EdgeInsets.fromLTRB(0.0, 25.0, 2.0, 0.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: iris_100,
              ),
              child: TextButton(
                onPressed: () async {
                  // BLE 검색 시작
                  FlutterBluePlus.startScan(
                    timeout: Duration(seconds: 15),
                  );

                  // 검색된 디바이스 리스닝
                  var subscription =
                      FlutterBluePlus.scanResults.listen((results) {
                    // 결과 처리
                    setState(() {
                      if (mounted) {
                        scanResults = results;
                      }
                    });

                    // ESP32 장치를 찾으면 자동으로 연결 시도
                    for (var result in results) {
                      if (result.device.platformName == "ESP32") {
                        FlutterBluePlus.stopScan();
                        //subscription.cancel();
                        connectToDevice(result.device);
                        break;
                      }
                    }
                  });

                  // 검색 종료
                  await Future.delayed(Duration(seconds: 15));
                  FlutterBluePlus.stopScan();
                  subscription.cancel();
                },
                child: Text(
                  '블루투스 스캔하기',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'PretandardMedium',
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
            connectedDevice == null
                ? Container()
                : Column(
                    children: [
                      Text('Connected to ${connectedDevice!.name}'),
                      TextField(
                        controller: distanceController,
                        decoration: InputDecoration(
                          labelText: 'Enter distance',
                        ),
                      ),
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
            Expanded(
              child: ListView.builder(
                itemCount: scanResults.length,
                itemBuilder: (context, index) {
                  final result = scanResults[index];
                  return Card(
                    child: ListTile(
                      title: Text(result.device.name.isNotEmpty
                          ? result.device.name
                          : 'Unknown Device'),
                      subtitle: Text('RSSI: ${result.rssi}'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
