import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:controller_app/services/app_logger.dart';

class Buzz extends StatefulWidget {
  final BluetoothDevice device;

  const Buzz({super.key, required this.device});

  @override
  State<Buzz> createState() => _BuzzState();
}

class _BuzzState extends State<Buzz> {
  BluetoothCharacteristic? buzzCharacteristic;
  StreamSubscription<BluetoothConnectionState>? _connectionSubscription;

  final TextEditingController secondsController = TextEditingController();

  void startBuzz(int seconds) async {
    try {
      if (buzzCharacteristic == null) {
        AppLogger.warning("Buzz characteristic is null");
        return;
      }

      final message = "$seconds";
      AppLogger.ble("Writing buzz command: $message");

      await buzzCharacteristic!.write(
        message.codeUnits,
        withoutResponse: false,
      );

    } catch (e) {
      AppLogger.error("Buzz write failed", e);
    }
  }

  @override
  void initState() {
    super.initState();
    discoverServices();
    _connectionSubscription = widget.device.connectionState.listen((state) {
      AppLogger.ble("Buzz connection state: $state");
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

    AppLogger.ble("Buzz characteristic found: $buzzCharacteristic");
  }

  @override
  void dispose() {
    _connectionSubscription?.cancel();
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
                  AppLogger.warning("Invalid buzz duration");
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
