// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:intl/intl.dart';
// import 'package:running_mate/src/theme/colors.dart';
// import 'package:running_mate/src/screens/SetGoalScreen.dart';
// import 'package:running_mate/src/screens/MyRecordScreen.dart';
// import 'package:running_mate/src/screens/TimerPage.dart';
// import 'package:running_mate/src/screens/TimerScreen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_blue/flutter_blue.dart';

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   FlutterBlue flutterBlue = FlutterBlue.instance;

//   TextEditingController distanceController = TextEditingController();
//   TextEditingController timeController = TextEditingController();

//   BluetoothDevice device;
//   BluetoothCharacteristic characteristic;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('ESP32 통신'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             TextField(
//               controller: distanceController,
//               decoration: InputDecoration(labelText: '달릴 거리'),
//             ),
//             TextField(
//               controller: timeController,
//               decoration: InputDecoration(labelText: '목표 시간'),
//             ),
//             TextButton(
//               onPressed: _sendData,
//               child: Text('전송'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _sendData() {
//     String distance = distanceController.text;
//     String time = timeController.text;

//     String data = '$distance:$time';

//     if (characteristic != null) {
//       characteristic.write(data.codeUnits);
//     }
//   }

//   void _connectToDevice() async {
//     List<BluetoothDevice> devices = await flutterBlue.connectedDevices;
//     for (BluetoothDevice dev in devices) {
//       if (dev.name == 'ESP32') {
//         device = dev;
//         break;
//       }
//     }

//     if (device == null) {
//       List<ScanResult> results =
//           await flutterBlue.scan(timeout: Duration(seconds: 4));
//       for (ScanResult result in results) {
//         if (result.device.name == 'ESP32') {
//           device = result.device;
//           break;
//         }
//       }
//     }

//     if (device != null) {
//       await device.connect();
//       List<BluetoothService> services = await device.discoverServices();
//       for (BluetoothService service in services) {
//         for (BluetoothCharacteristic characteristic
//             in service.characteristics) {
//           if (characteristic.uuid.toString() == 'YOUR_CHARACTERISTIC_UUID') {
//             this.characteristic = characteristic;
//             break;
//           }
//         }
//       }
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _connectToDevice();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     device?.disconnect();
//   }
// }
