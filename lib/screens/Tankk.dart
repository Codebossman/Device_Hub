import 'package:controller_app/MyWidgets/DeviceCard.dart';
import 'package:controller_app/screens/Devices.dart';
import 'package:controller_app/screens/Home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:controller_app/commands/MotorCommands.dart';

class Controller extends StatefulWidget {
  final BluetoothDevice device;
  final VoidCallback? onExit;

  const Controller({super.key, required this.device, required this.onExit});

  @override
  State<Controller> createState() => _ControllerState();
}

class _ControllerState extends State<Controller> {
  double leftSpeed = 0;
  double rightSpeed = 0;

  
  @override
  void initState() {
    super.initState();
    discoverServices();
    widget.device.connectionState.listen((state) {
      debugPrint("Connection state: $state");
    });
  }

  Future<void> discoverServices() async {
    List<BluetoothService> services = await widget.device.discoverServices();

    for (var service in services) {
      if (service.uuid.toString().contains("1234")) {
        for (var characteristic in service.characteristics) {
          if (characteristic.uuid.toString().contains("5678")) {
            motorCharacteristic = characteristic;
          }
        }
      }
    }

    debugPrint("Characteristic found: $motorCharacteristic");
  }

  // we'll plug BLE write here next@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Controller"), leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          widget.onExit?.call();
          
        },
        ),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // LEFT MOTOR
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Left Motor"),
                const SizedBox(height: 10),
                SizedBox(
                  height: 300,
                  child: RotatedBox(
                    quarterTurns: -1,
                    child: Slider(
                      activeColor: Colors.blue,
                      value: leftSpeed,
                      min: -255,
                      max: 255,
                      divisions: 510,
                      onChanged: (value) {
                        setState(() {
                          leftSpeed = value;
                        });
                        sendMotorCommand("B", (value.toInt()));
                      },
                    ),
                  ),
                ),
                Text(leftSpeed.toInt().toString()),
              ],
            ),

            // RIGHT MOTOR
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Right Motor"),
                const SizedBox(height: 10),
                SizedBox(
                  height: 300,
                  child: RotatedBox(
                    quarterTurns: -1,
                    child: Slider(
                      activeColor: Colors.blue,
                      value: rightSpeed,
                      min: -255,
                      max: 255,
                      divisions: 510,
                      onChanged: (value) {
                        setState(() {
                          rightSpeed = value;
                        });
                        sendMotorCommand("A", value.toInt());
                      },
                    ),
                  ),
                ),
                Text(rightSpeed.toInt().toString()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
