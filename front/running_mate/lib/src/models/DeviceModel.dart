import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class DeviceModel {
  BluetoothDevice? device;
  late String name;
  late DeviceIdentifier id;
  late bool isConnected;
  late int rssi;

  DeviceModel(
      {required this.device,
      required this.name,
      required this.id,
      required this.isConnected,
      required this.rssi});

  factory DeviceModel.fromScan(ScanResult result) {
    return DeviceModel(
      device: result.device,
      name: result.device.platformName,
      id: result.device.remoteId,
      isConnected: false,
      rssi: result.rssi,
    );
  }
}
