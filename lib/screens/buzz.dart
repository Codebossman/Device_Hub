import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class Buzz extends StatefulWidget {
  const Buzz({super.key});

  @override
  State<Buzz> createState() => _BuzzState();
}

class _BuzzState extends State<Buzz> {
  BluetoothCharacteristic? buzzCharacteristic;

  TextEditingController secondsController = TextEditingController();

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
