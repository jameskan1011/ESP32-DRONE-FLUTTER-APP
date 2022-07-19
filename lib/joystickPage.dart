import 'dart:ffi';

import 'package:esp_bluetooth/controlPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'controlPage.dart';

const step = 10.0;
const ballSize = 20.0;

// class JoystickPage extends StatelessWidget {
//   const JoystickPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: double.infinity,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           ElevatedButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) => const JoystickExample(device: ,)),
//               );
//             },
//             child: const Text('Joystick'),
//           ),
//         ],
//       ),
//     );
//   }
// }

class JoystickExample extends ControlPage {
  const JoystickExample({Key? key, required this.device})
      : super(key: key, device: device);
  final BluetoothDevice device;

  @override
  JoystickExampleState createState() => JoystickExampleState();
}

class JoystickExampleState extends ControlPageState<JoystickExample> {
  late String _x1;
  late String data;
  late String _y1;

  JoystickMode _joystickMode = JoystickMode.all;

  @override
  void initState() {
    _x1 = "100";
    _y1 = "100";
    data = "0";
    super.initState();
  }

  @override
  dynamic mySetState(String data) {
    setState(() {
      //String data = "0";
      writeData(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        title: const Text('Joystick Area'),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              // alignment: Alignment.bottomRight,
              margin: EdgeInsets.only(top: 50, bottom: 50, left: 50),
              width: 200,
              height: 200,
              child: Joystick(
                onStickDragEnd: mySetState(data),
                onStickDragStart: mySetState(data),
                mode: _joystickMode,

                period: const Duration(milliseconds: 150),
                //initialJoystickAlignment: Alignment.bottomLeft,
                listener: (details) {
                  setState(() {
                    _x1 = (details.x * 100).toStringAsFixed(2);
                    _y1 = (details.y * 100).toStringAsFixed(2);

                    String data = "$_x1, $_y1\n";
                    //
                    writeData(data);
                    //print(data);
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
