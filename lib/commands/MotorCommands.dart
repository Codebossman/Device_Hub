import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';


void sendMotorCommand(String motor, int speed) async {
    try {
      if (motorCharacteristic == null) {
        debugPrint("Characteristic is NULL");
        return;
      }

      final message = "$motor:$speed";
      debugPrint("Writing: $message");

      await motorCharacteristic!.write(
        message.codeUnits,
        withoutResponse: false,
      );

      debugPrint("Write successful");
    } catch (e) {
      debugPrint("WRITE ERROR: $e");
    }
  }

  BluetoothCharacteristic? motorCharacteristic;
  BluetoothCharacteristic? doorCharacteristic;
