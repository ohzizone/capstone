import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:running_mate/src/constants/flutter_blue_const.dart';

import '../model/bluetooth_device_model.dart';

class BluetoothDiscovery {
  static Stream<List<DeviceModel>> getDevices() {
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));
    return FlutterBluePlus.scanResults.map((results) {
      List<DeviceModel> devices = [];
      for (var result in results) {
        if (result.device.platformName == 'LED BLE MESH SERVER') {
          final device = DeviceModel.fromScan(result);
          devices.add(device);
        }
      }
      return devices;
    });
  }

  static Future<List<DeviceModel>> getConnectedDevices() async {
    List<BluetoothDevice> connects = await FlutterBluePlus.connectedDevices;

    List<DeviceModel> devices = [];
    for (var connect in connects) {
      final device = DeviceModel.fromAlreadyConnect(connect);
      devices.add(device);
    }
    return devices;
  }
}
