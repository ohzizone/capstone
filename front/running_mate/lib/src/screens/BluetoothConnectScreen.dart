import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:io' show Platform;

class BluetoothScreen extends StatefulWidget {
  @override
  _BluetoothScreenState createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  FlutterBluePlus flutterBlue = FlutterBluePlus();
  List<BluetoothDevice> connectedDevices = [];
  bool isScanning = false;
  List<ScanResult> scanResults = [];

  @override
  void initState() {
    super.initState();
    checkBluetoothSupportAndState();
    getConnectedDevice();
  }

  Future<void> checkBluetoothSupportAndState() async {
    // Check if Bluetooth is supported
    if (await FlutterBluePlus.isSupported == false) {
      print("Bluetooth not supported by this device");
      return;
    }

    // Handle Bluetooth on & off state
    var subscription =
        FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) {
      print(state);
      if (state == BluetoothAdapterState.on) {
        // Usually start scanning, connecting, etc
        startScan();
      } else {
        // Show an error to the user, etc
        print("Bluetooth is not on");
      }
    });

    // Turn on Bluetooth on Android
    if (Platform.isAndroid) {
      await FlutterBluePlus.turnOn();
    }

    // Cancel the subscription to prevent duplicate listeners
    subscription.cancel();
  }

  Future<void> getConnectedDevice() async {
    connectedDevices = await FlutterBluePlus.connectedDevices;
    setState(() {}); // Update the UI
  }

  void startScan() {
    setState(() {
      isScanning = true;
      scanResults.clear();
    });
    try {
      FlutterBluePlus.scan().listen((scanResult) {
        setState(() {
          scanResults.add(scanResult);
        });
      });
    } catch (e) {
      print('error : ${e.toString()}');
    }
  }

  // Future<void> stopScan() async {
  //   setState(() {
  //     isScanning = false;
  //   });
  //   await flutterBlue.stopScan();
  // }

  Widget ConnectedDevices() {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: const Text(
            'Connected Devices',
            style: TextStyle(
                color: Colors.blue, fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: connectedDevices.length,
            itemBuilder: (context, index) {
              var connectedDevice = connectedDevices[index];
              return Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.lightBlue[100],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.bluetooth),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          connectedDevice.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'ID : [${connectedDevice.id.toString()}]',
                          style: const TextStyle(
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.lightBlue[50]),
                          ),
                          onPressed: () {
                            connectedDevice.disconnect();
                            setState(() {
                              connectedDevices.remove(connectedDevice);
                            });
                          },
                          child: const Text('Disconnect'),
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Colors.orangeAccent[700]),
                          ),
                          onPressed: () {
                            // TODO: Navigate to DeviceScreen with the selected device
                          },
                          child: const Text('Device..'),
                        )
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget ScanningDevices() {
    return Column(
      children: [
        Row(
          children: [
            ElevatedButton(
              onPressed: isScanning ? null : startScan,
              child: Text(isScanning ? 'Scanning...' : 'Scan'),
            ),
            // ElevatedButton(
            //   onPressed: stopScan,
            //   child: const Text('Stop!'),
            // ),
          ],
        ),
        Container(
          alignment: Alignment.centerLeft,
          child: const Text(
            'Scanning Devices',
            style: TextStyle(
                color: Colors.blue, fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: scanResults.length,
            itemBuilder: (BuildContext context, int index) {
              var scanResult = scanResults[index];
              if (scanResult.device.name.isNotEmpty) {
                return Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 5.0, vertical: 5.0),
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey[200],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.bluetooth),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            scanResult.device.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'ID : [${scanResult.device.id.toString()}]',
                            style: const TextStyle(
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.lightBlue[50]),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.black)),
                        onPressed: () {
                          scanResult.device.connect();
                          setState(() {
                            scanResults.remove(scanResult);
                            connectedDevices.add(scanResult.device);
                          });
                        },
                        child: const Text('Connect'),
                      ),
                    ],
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth Screen'),
      ),
      body: Column(
        children: [
          Flexible(
            flex: 1,
            child: ConnectedDevices(),
          ),
          Flexible(
            flex: 4,
            child: ScanningDevices(),
          ),
        ],
      ),
    );
  }
}
