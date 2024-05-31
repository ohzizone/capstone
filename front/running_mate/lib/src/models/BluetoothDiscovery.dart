import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:running_mate/src/models/DeviceModel.dart';

class BluetoothDiscovery {
  // static을 통해 함수를 클래스에 귀속
  static Stream<List<DeviceModel>> getDevices() {
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));
    return FlutterBluePlus.scanResults.map((results) {
      List<DeviceModel> devices = [];
      for (var result in results) {
        if (result.device.name == 'LED BLE MESH SERVER') {
          final device = DeviceModel.fromScan(result);
          devices.add(device);
        }
      }
      return devices;
    });
  }
}

class BluetoothRepository {
  static Stream<List<DeviceModel>> getDevices() =>
      BluetoothDiscovery.getDevices();
}
