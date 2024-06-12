import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class FlutterBlueApp extends StatefulWidget {
  @override
  _BluetoothPageState createState() => _BluetoothPageState();
}

class _BluetoothPageState extends State<FlutterBlueApp> {
  // FlutterBluePlus 인스턴스 생성
  FlutterBluePlus flutterBlue = FlutterBluePlus();
  BluetoothDevice? _connectedDevice;
  List<BluetoothService> _services = [];

  @override
  void initState() {
    super.initState();
    startScan();
  }

  void startScan() {
    FlutterBluePlus.startScan(timeout: Duration(seconds: 4));

    var subscription = FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult r in results) {
        if (r.device.platformName == 'RunningMate') {
          // HM-10의 기본 이름
          connectToDevice(r.device);
          FlutterBluePlus.stopScan();
          break;
        }
      }
    });

    FlutterBluePlus.isScanning.listen((isScanning) {
      if (!isScanning) {
        subscription.cancel();
      }
    });
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    await device.connect();
    _connectedDevice = device;
    _services = await device.discoverServices();
    setState(() {});
  }

  void sendData(String data) async {
    if (_connectedDevice != null) {
      for (BluetoothService service in _services) {
        for (BluetoothCharacteristic characteristic
            in service.characteristics) {
          if (characteristic.properties.write) {
            await characteristic.write(data.codeUnits);
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth HM-10'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _connectedDevice != null
                  ? 'Connected to ${_connectedDevice!.platformName}'
                  : 'Searching for devices...',
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _connectedDevice != null
                  ? () => sendData('Hello HM-10')
                  : null,
              child: Text('Send Data'),
            ),
          ],
        ),
      ),
    );
  }
}
