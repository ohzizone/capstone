import 'package:running_mate/src/models/DeviceModel.dart';
import 'package:running_mate/src/models/BluetoothDiscovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

class BluetoothController extends GetxController {
  final _result = Rx<List<DeviceModel>>([]); //검색결과를 담는 변수

  List<DeviceModel> get result => _result.value; //검색결과 getter

  @override
  void onInit() {
    //컨트롤러가 초기화될 경우 실행
    super.onInit();
    startScan();
  }

  void startScan() {
    //장치를 검색하는 함수
    _result.bindStream(BluetoothRepository.getDevices());
  }
}
