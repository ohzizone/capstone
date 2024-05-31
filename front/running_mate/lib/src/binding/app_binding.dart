import 'package:running_mate/src/controller/bluetooth_controller.dart';
import 'package:get/get.dart';

class AppBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(BluetoothController());
  }
}
