import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:running_mate/src/binding/init_binding.dart';
import 'package:running_mate/src/view/onboard.dart';
import 'package:get/get.dart';

class BluetoothScreenTestWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: Get.key,
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xff303c3d),
              foregroundColor: Colors.white,
              elevation: 0.0),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Colors.white, foregroundColor: Colors.black)),
      home: const OnBoard(),
      initialBinding: InitBinding(),
    );
  }
}
