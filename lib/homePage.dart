import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:convert' show utf8;
import 'controlPage.dart';
import 'widgets.dart';

class HomePage extends ControlPage {
  const HomePage({Key? key, required this.device})
      : super(key: key, device: device);
  final BluetoothDevice device;

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends ControlPageState<HomePage> {
  //late BluetoothCharacteristic targetCharacteristic;

  // writeData(String data) async {
  //   if (targetCharacteristic == null) return;

  //   List<int> bytes = utf8.encode(data);
  //   await targetCharacteristic.write(bytes);
  //   print(bytes);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        children: [
          Text('Forward'),
          TextButton.icon(
              onPressed: () {
                writeData('5');
              },
              icon: Icon(Icons.arrow_upward),
              label: Text('up')),
          Text('Backward'),
          TextButton.icon(
              onPressed: () {
                //writeData('5');
              },
              icon: Icon(Icons.arrow_downward),
              label: Text('down'))
        ],
      )),
    );
  }
}
