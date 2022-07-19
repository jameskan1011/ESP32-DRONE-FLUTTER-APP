import 'dart:async';
import 'dart:convert' show utf8;

import 'package:esp_bluetooth/homePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class ControlPage extends StatefulWidget {
  const ControlPage({Key? key, required this.device}) : super(key: key);
  final BluetoothDevice device;

  @override
  State<ControlPage> createState() => ControlPageState();
}

class ControlPageState<T extends ControlPage> extends State<T> {
  String service_uuid = "4fafc201-1fb5-459e-8fcc-c5c9c331914b";
  String charaCteristic_uuid = "beb5483e-36e1-4688-b7f5-ea07361b26a8";
  late BluetoothCharacteristic targetCharacteristic;
  late bool isReady;
  late Stream<List<int>> stream;

  @override
  void initState() {
    super.initState();
    isReady = false;
    connectToDevice();
  }

  void dispose() {
    widget.device.disconnect();
    super.dispose();
  }

  connectToDevice() async {
    if (widget.device == null) {
      _pop();
      return;
    }

    new Timer(const Duration(seconds: 15), () {
      if (!isReady) {
        disconnectFromDevice();
        _pop();
      }
    });

    await widget.device.connect();
    discoverServices();
  }

  disconnectFromDevice() {
    if (widget.device == null) {
      _pop();
      return;
    }

    widget.device.disconnect();
  }

  discoverServices() async {
    if (widget.device == null) {
      _pop();
      return;
    }

    List<BluetoothService> services = await widget.device.discoverServices();
    services.forEach((service) {
      if (service.uuid.toString() == service_uuid) {
        service.characteristics.forEach((characteristic) {
          if (characteristic.uuid.toString() == charaCteristic_uuid) {
            characteristic.setNotifyValue(!characteristic.isNotifying);
            targetCharacteristic = characteristic;
            stream = characteristic.value;

            setState(() {
              isReady = true;
            });
          }
        });
      }
    });

    if (!isReady) {
      _pop();
    }
  }

  Future<bool> _onWillPop() async {
    return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Are you sure?'),
              content: Text('Do you want to disconnect device and go back?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: new Text('No'),
                ),
                TextButton(
                    onPressed: () {
                      disconnectFromDevice();
                      Navigator.of(context).pop(true);
                    },
                    child: new Text('Yes')),
              ],
            ));
  }

  _pop() {
    Navigator.of(context).pop(true);
  }

  String _dataParser(List<int> dataFromDevice) {
    return utf8.decode(dataFromDevice);
  }

  writeData(String data) async {
    if (targetCharacteristic == null) return;

    List<int> bytes = utf8.encode(data);
    await targetCharacteristic.write(bytes);
    print(bytes);
  }

  // writeData() async {
  //   if (targetCharacteristic == null) return;

  //   for (int a = 0; a < 1000; a++) {
  //     List<int> data = [a];
  //     await targetCharacteristic.write(data);
  //     print(data);
  //     await Future.delayed(const Duration(seconds: 1));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text('ControlPage'),
        ),
        body: Container(
            child: !isReady
                ? Center(
                    child: Text(
                      "Waiting...",
                      style: TextStyle(fontSize: 24, color: Colors.red),
                    ),
                  )
                : Container(
                    child: StreamBuilder<List<int>>(
                      stream: stream,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<int>> snapshot) {
                        if (snapshot.hasError)
                          return Text('Error: ${snapshot.error}');

                        if (snapshot.connectionState ==
                            ConnectionState.active) {
                          // geting data from bluetooth
                          return Container(
                            child: TextButton.icon(
                                onPressed: () {
                                  writeData('5');
                                },
                                icon: Icon(Icons.arrow_upward),
                                label: Text('forward')),
                          );

                          //return HomePage();
                        } else {
                          return Text('Check the stream');
                        }
                      },
                    ),
                  )),
      ),
    );
  }
}
