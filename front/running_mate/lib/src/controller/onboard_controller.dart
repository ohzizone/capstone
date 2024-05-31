import 'package:get/get.dart';

import '../binding/app_binding.dart';
import '../view/home.dart';

class OnboardController extends GetxController {
  void moveToScan() {
    print('홈으로 간다');
    Get.off(() => const Home(),
        binding: AppBinding(), transition: Transition.fadeIn);
  }
}
