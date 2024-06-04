import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:running_mate/src/theme/colors.dart';

class FlutterBlueApp extends StatefulWidget {
  @override
  _FlutterBlueAppState createState() => _FlutterBlueAppState();
}

class _FlutterBlueAppState extends State<FlutterBlueApp> {
  // FlutterBluePlus 인스턴스 생성
  FlutterBluePlus flutterBlue = FlutterBluePlus();
  // 검색된 BLE 장치 목록을 저장할 리스트
  List<ScanResult> scanResults = [];

  @override
  void initState() {
    super.initState();
    initializeBluetooth(); // Bluetooth 설정 초기화
  }

  // Bluetooth 설정 초기화 및 지원 여부 확인
  Future<bool> initializeBluetooth() async {
    try {
      // 로그 레벨 설정 (상세 로깅 활성화)
      await FlutterBluePlus.setLogLevel(LogLevel.verbose);
      // Bluetooth 옵션 설정
      await FlutterBluePlus.setOptions(
          // {BluetoothOptions(}
          //   requestMtu: 512, // 원하는 MTU 설정 (Android)
          //   autoConnect: false, // 기본값으로 자동 연결 비활성화
          // ),
          );

      // Bluetooth 기능 지원 여부 확인
      if (await FlutterBluePlus.isSupported == false) {
        print("Bluetooth not supported by this device");
        Fluttertoast.showToast(
          msg: "Bluetooth not supported by this device",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
        return false;
      }

      // Bluetooth가 켜져 있는지 확인
      if (await FlutterBluePlus.isOn == false) {
        print("블루투스를 켜주세요");
        Fluttertoast.showToast(
          msg: "블루투스를 켜주세요",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
        return false;
      }
      return true;
    } catch (e) {
      print("Error initializing Bluetooth: $e");
      Fluttertoast.showToast(
        msg: "Error initializing Bluetooth: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          '블루투스 예제',
          style: TextStyle(
            color: Colors.black87,
            fontFamily: 'PretandardMedium',
            //fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('블루투스 예제'),
            Container(
              margin: EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: iris_100,
              ),
              height: 65.0,
              width: 200.0,
              child: TextButton(
                onPressed: () async {
                  // Bluetooth가 켜져 있는지 확인
                  bool isBluetoothOn = await initializeBluetooth();
                  if (!isBluetoothOn) return;

                  // BLE 검색 시작
                  FlutterBluePlus.startScan(
                    timeout: Duration(seconds: 15),
                    //withServices: [Guid("180D")], // 서비스 UUID로 필터링 (선택 사항)
                    //withNames: ["Bluno"], // 필터링 기준 장치 이름(선택 사항)
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
                  });

                  // 검색 종료
                  await Future.delayed(Duration(seconds: 60));
                  FlutterBluePlus.stopScan();
                  subscription.cancel();
                },
                child: Text(
                  '블루투스 스캔하기',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'PretandardMedium',
                    //fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: scanResults.length,
                itemBuilder: (context, index) {
                  final result = scanResults[index];
                  return Card(
                    child: ListTile(
                      title: Text(result.device.platformName.isNotEmpty
                          ? result.device.platformName ?? 'Unknown Device'
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
