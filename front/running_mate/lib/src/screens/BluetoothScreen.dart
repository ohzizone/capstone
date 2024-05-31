import 'package:running_mate/src/models/DeviceModel.dart';
import 'package:running_mate/src/models/BluetoothDiscovery.dart';
import 'package:running_mate/src/controllers/BluetoothController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

class BluetoothScreen extends StatelessWidget {
  final BluetoothController _bluetoothController =
      Get.put(BluetoothController());

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
            ElevatedButton(
              onPressed: () async {
                _bluetoothController.startScan();
              },
              child: Text('Scan for Devices'),
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
