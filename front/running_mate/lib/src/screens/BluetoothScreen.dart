import 'package:running_mate/src/models/DeviceModel.dart';
import 'package:running_mate/src/models/BluetoothDiscovery.dart';
import 'package:running_mate/src/controllers/BluetoothController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:running_mate/src/theme/colors.dart';

class BluetoothScreen extends StatelessWidget {
  final BluetoothController _bluetoothController =
      Get.put(BluetoothController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('블루투스 연결'),
        backgroundColor: Colors.white,
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
                  _bluetoothController.startScan();
                },
                child: Text(
                  '블루투스 연결하기 >',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'PretandardMedium',
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Obx(() => ListView.builder(
                    itemCount: _bluetoothController.result.length,
                    itemBuilder: (context, index) {
                      final result = _bluetoothController.result[index];
                      return Card(
                        child: ListTile(
                          title: Text(result.name.isNotEmpty
                              ? result.name ?? 'Unknown Device'
                              : 'Unknown Device'),
                          subtitle: Text('RSSI: ${result.rssi}'),
                        ),
                      );
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
