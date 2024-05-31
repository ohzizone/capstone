import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class DeviceModel {
  BluetoothDevice? device;
  late String name;
  late DeviceIdentifier id;
  late bool isConnected;

  DeviceModel(
      {required this.device,
      required this.name,
      required this.id,
      required this.isConnected});

  factory DeviceModel.fromScan(ScanResult result) {
    return DeviceModel(
      device: result.device,
      name: result.device.name,
      id: result.device.id,
      isConnected: false,
    );
  }

  factory DeviceModel.fromAlreadyConnect(BluetoothDevice device) {
    return DeviceModel(
      device: device,
      name: device.name,
      id: device.id,
      isConnected: true,
    );
  }
}
