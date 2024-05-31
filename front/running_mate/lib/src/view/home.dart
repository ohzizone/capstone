import 'package:flutter/material.dart';
import 'package:running_mate/src/components/background.dart';
import 'package:running_mate/src/components/connect_item.dart';
import 'package:running_mate/src/components/result_item.dart';
import 'package:running_mate/src/components/no_result.dart';
import 'package:running_mate/src/components/rive_image.dart';
import 'package:running_mate/src/view/connect.dart';
import 'package:get/get.dart';

import '../controller/bluetooth_controller.dart';

class Home extends GetView<BluetoothController> {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Obx(
          () => FloatingActionButton.extended(
            onPressed: controller.fabAction,
            label: (controller.status == Status.LOADING)
                ? const Text('Stop')
                : const Text('Scan'),
            icon: (controller.status == Status.LOADING)
                ? const Icon(Icons.square)
                : const Icon(Icons.search),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        extendBodyBehindAppBar: true,
        body: BackGround(
          child: Obx(
            () => _home(),
          ),
        ));
  }

  Widget _home() {
    return SafeArea(
      child: ListView(
        children: [
          _already(),
          _result(),
        ],
      ),
    );
  }

  Widget _already() {
    return (controller.already.isEmpty)
        ? Container()
        : Column(
            children: [
              const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      'Connect LED\'s',
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: controller.already.length,
                  itemBuilder: (context, index) {
                    final connect = controller.already[index];
                    return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ConnectItem(
                          data: connect,
                          disconnect: (_) {
                            controller.disconnect(connect);
                          },
                          move: () {
                            if (!connect.isConnected) {
                              return;
                            }
                            Get.to(() => Connect(
                                  deviceModel: connect,
                                ));
                          },
                        ));
                  }),
            ],
          );
  }

  Widget _result() {
    return (controller.result.isEmpty)
        ? _noResult()
        : Column(
            children: [
              const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      'Available LED\'s',
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: controller.result.length,
                itemBuilder: (context, index) {
                  final data = controller.result[index];
                  return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ResultItem(
                        data: data,
                        remove: (_) {
                          controller.removeDevice(index);
                        },
                        connect: (_) {
                          controller.connectDevice(data);
                        },
                        move: () {
                          if (!data.isConnected) {
                            return;
                          }
                          Get.to(() => Connect(
                                deviceModel: data,
                              ));
                        },
                      ));
                },
              ),
            ],
          );
  }

  Widget _scan() {
    return Center(
        child: RiveImage(
      imagePath: RiveAssetPath.search,
      height: 300,
      width: 300,
    ));
  }

  Widget _noResult() {
    return const NoResult(width: double.infinity, height: 300);
  }
}
