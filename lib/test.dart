import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class FindDevicesScreen extends StatelessWidget {
  const FindDevicesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Flexible(flex: 4, child: Container()),
      Flexible(
          flex: 1,
          child: Row(children: [
            const Text('Find Devices'),
            StreamBuilder<bool>(
              stream: FlutterBluePlus.instance.isScanning,
              initialData: false,
              builder: (c, snapshot) {
                if (snapshot.data!) {
                  return IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => FlutterBluePlus.instance.stopScan(),
                    color: Colors.red,
                  );
                } else {
                  return IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: () => FlutterBluePlus.instance
                          .startScan(timeout: const Duration(seconds: 4)));
                }
              },
            ),
          ])),
      Container(),
    ]);
  }
}
