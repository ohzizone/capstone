import 'dart:convert';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:running_mate/src/data/model/bluetooth_device_model.dart';

class BluetoothApi {
  static Future<void> connectDevice(DeviceModel deviceModel) async {
    deviceModel.device!.connect();
  }

  static Future<void> disconnect(DeviceModel deviceModel) async {
    await deviceModel.device!.disconnect();
  }

  static void sendData(BluetoothDevice device, String data) async {
    Guid serviceUuid = Guid(TargetBLE.serviceUuid);
    Guid characteristicUuid = Guid(TargetBLE.characteristicUuid);

    List<BluetoothService> services = await device.discoverServices();
    BluetoothService service =
        services.firstWhere((s) => s.uuid == serviceUuid);
    BluetoothCharacteristic characteristic =
        service.characteristics.firstWhere((c) => c.uuid == characteristicUuid);

    List<int> value = utf8.encode(data); // Convert string to byte list

    try {
      await characteristic.write(value);

      print("Data sent successfully");
    } catch (e) {
      print("error");
    }
  }

  static Future<List<int>> searchService(DeviceModel deviceModel) async {
    List<int> result = [];

    return deviceModel.device!.discoverServices().then((services) {
      for (var service in services) {
        if (service.uuid.toString() == TargetBLE.serviceUuid) {
          var cs = service.characteristics;
          for (BluetoothCharacteristic c in cs) {
            c.read().then((value) => result = value);
          }
        }
      }
      return result;
    });
  }
}

class TargetBLE {
  static String get serviceUuid => "4fafc201-1fb5-459e-8fcc-c5c9c331914b";
  static String get characteristicUuid =>
      "beb5483e-36e1-4688-b7f5-ea07361b26a8";
}
