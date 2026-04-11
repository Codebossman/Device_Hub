import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class Buzz extends StatefulWidget {
  final BluetoothDevice device;

  const Buzz({super.key, required this.device});

  @override
  State<Buzz> createState() => _BuzzState();
}

class _BuzzState extends State<Buzz> {
  BluetoothCharacteristic? buzzCharacteristic;

  final TextEditingController secondsController = TextEditingController();

  void startBuzz(int seconds) async {
    try {
      if (buzzCharacteristic == null) {
        debugPrint("Characteristic is NULL");
        return;
      }

      final message = "$seconds";
      debugPrint("Writing: $message");

      await buzzCharacteristic!.write(
        message.codeUnits,
        withoutResponse: false,
      );

      debugPrint("Write successful");
    } catch (e) {
      debugPrint("WRITE ERROR: $e");
    }
  }

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
            buzzCharacteristic = characteristic;
          }
        }
      }
    }

    debugPrint("Characteristic found: $buzzCharacteristic");
  }

  @override
  void dispose() {
    secondsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 12),
            SizedBox(
              width: 100,
              child: TextField(
                controller: secondsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Seconds",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                int? seconds = int.tryParse(secondsController.text);

                if (seconds != null) {
                  startBuzz(seconds);
                } else {
                  debugPrint("Invalid number");
                }
              },
              child: Icon(Icons.play_arrow),
            ),
            SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}
