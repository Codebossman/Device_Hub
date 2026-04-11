import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:controller_app/services/app_logger.dart';


void sendMotorCommand(String motor, int speed) async {
    try {
      if (motorCharacteristic == null) {
        AppLogger.warning("Motor characteristic is null");
        return;
      }

      final message = "$motor:$speed";
      AppLogger.ble("Writing motor command: $message");

      await motorCharacteristic!.write(
        message.codeUnits,
        withoutResponse: false,
      );

    } catch (e) {
      AppLogger.error("Motor write failed", e);
    }
  }

  BluetoothCharacteristic? motorCharacteristic;
  BluetoothCharacteristic? doorCharacteristic;
