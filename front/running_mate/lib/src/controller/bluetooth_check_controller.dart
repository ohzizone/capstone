import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:running_mate/src/view/check.dart';
import 'package:running_mate/src/view/onboard.dart';
import 'package:get/get.dart';

import '../constants/flutter_blue_const.dart';

class BluetoothCheckController extends GetxController {
  final _bluetoothState =
      Rx<BluetoothAdapterState>(BluetoothAdapterState.unknown);

  set bluetoothState(value) => _bluetoothState.value = value;

  @override
  void onReady() {
    super.onReady();
    ever(_bluetoothState, (_) => moveToPage());
    _bluetoothState.bindStream(FlutterBluePlus.adapterState);
  }

  void moveToPage() {
    if (_bluetoothState.value == BluetoothAdapterState.on) {
      Get.off(() => const OnBoard(), transition: Transition.fadeIn);
    } else {
      Get.off(() => const Check(), transition: Transition.fadeIn);
    }
  }
}
