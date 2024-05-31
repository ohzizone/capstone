import 'package:flutter/material.dart';
import 'package:running_mate/src/components/gradient_button.dart';
import 'package:running_mate/src/components/rive_image.dart';
import 'package:running_mate/src/controller/bluetooth_controller.dart';
import 'package:running_mate/src/data/model/bluetooth_device_model.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class Connect extends StatefulWidget {
  final DeviceModel deviceModel;
  bool current;
  Connect({super.key, required this.deviceModel, this.current = false});

  @override
  State<Connect> createState() => _ConnectState();
}

class _ConnectState extends State<Connect> {
  late List<String> values;

  @override
  void initState() {
    super.initState();
    initStatus();
  }

  initStatus() async {
    var result =
        await Get.find<BluetoothController>().searchService(widget.deviceModel);
    if (result != []) {
      print(String.fromCharCodes(result));
      setState(() {
        if (String.fromCharCodes(result) == '1') {
          widget.current = false;
        } else {
          widget.current = true;
        }
      });
    } else {
      print("Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("LED Server"),
      ),
      body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [
                  0.1,
                  0.4,
                  0.6,
                ],
                colors: [
                  Color(0xff081c1d),
                  Color(0xff0b2a2d),
                  Color(0xff0d393f),
                ]),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _usage(),
              _led(),
              _nextBtn(),
            ],
          )),
    );
  }

  Widget _led() {
    return Center(
      child: GetBuilder<BluetoothController>(
        builder: (controller) => GestureDetector(
          onTap: () async {
            if (widget.current) {
              controller.sendData(widget.deviceModel.device!, "0");
            } else {
              controller.sendData(widget.deviceModel.device!, "1");
            }
            setState(() {
              widget.current = !widget.current;
            });
          },
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100.0),
                child: RiveImage(
                  imagePath: (widget.current)
                      ? RiveAssetPath.ledOn
                      : RiveAssetPath.ledOff,
                  width: 300,
                  height: 300,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _nextBtn() {
    return GetBuilder<BluetoothController>(
      builder: (controller) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        child: GradientButton(
          colors: const [
            Color(0xfffc4032),
            Color(0xffde6057),
          ],
          width: 150,
          height: 50,
          onPressed: () => controller.disconnect(widget.deviceModel),
          child: const Text(
            'Disconnect',
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }

  Widget _usage() {
    return const Text(
      "tap : LED ON/OFF",
      style: TextStyle(color: Colors.white, fontSize: 30),
    );
  }
}
