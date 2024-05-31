import 'package:flutter/material.dart';
import 'package:running_mate/src/components/background.dart';
import 'package:running_mate/src/components/gradient_button.dart';
import 'package:running_mate/src/components/rive_image.dart';
import 'package:running_mate/src/controller/onboard_controller.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class OnBoard extends GetView<OnboardController> {
  const OnBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackGround(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _logo(),
            _title(),
            _description(),
            _nextBtn(),
          ],
        ),
      ),
    );
  }

  Widget _logo() {
    return RiveImage(imagePath: RiveAssetPath.onboard, width: 400, height: 400);
  }

  Widget _title() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      child: Text(
        'Welcome to HanSangWook BLE App.',
        style:
            TextStyle(fontFamily: 'Roboto', color: Colors.white, fontSize: 30),
      ),
    );
  }

  Widget _description() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      child: Text(
        'This app easily scans for nearby bluetooth LED devices and connects, control them quickly.',
        style:
            TextStyle(fontFamily: 'Roboto', color: Colors.white, fontSize: 15),
      ),
    );
  }

  Widget _nextBtn() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
      child: GradientButton(
        width: 150,
        height: 50,
        onPressed: controller.moveToScan,
        colors: const [
          Color(0xff03b6dc),
          Color(0xff69e4ff),
        ],
        child: const Text(
          'Start',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
