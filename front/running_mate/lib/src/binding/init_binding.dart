import 'package:running_mate/src/controller/bluetooth_check_controller.dart';
import 'package:get/get.dart';

import '../controller/onboard_controller.dart';

class InitBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(OnboardController());
    Get.put(BluetoothCheckController(), permanent: true);
  }
}
