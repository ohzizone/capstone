import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class FlutterBlueApp extends StatefulWidget {
  @override
  _FlutterBlueAppState createState() => _FlutterBlueAppState();
}

class _FlutterBlueAppState extends State<FlutterBlueApp> {
  FlutterBluePlus flutterBlue = FlutterBluePlus(); // 새로운 인스턴스를 생성
  List<ScanResult> scanResults = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Blue Plus Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Flutter Blue Plus Example'),
            ElevatedButton(
              onPressed: () async {
                // BLE 검색 시작
                FlutterBluePlus.startScan(timeout: Duration(seconds: 60));

                // 검색된 디바이스 리스닝
                var subscription =
                    FlutterBluePlus.scanResults.listen((results) {
                  // 결과 처리
                  setState(() {
                    scanResults = results;
                  });
                });

                // 검색 종료
                await Future.delayed(Duration(seconds: 4));
                FlutterBluePlus.stopScan();
                subscription.cancel();
              },
              child: Text('Scan for Devices'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: scanResults.length,
                itemBuilder: (context, index) {
                  final result = scanResults[index];
                  return Card(
                    child: ListTile(
                      title: Text(result.device.name.isNotEmpty
                          ? result.device.platformName
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
