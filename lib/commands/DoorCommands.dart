import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:controller_app/services/app_logger.dart';


void sendDoorCommand() async {
  try {
    if (doorCharacteristic == null) {
      AppLogger.warning("Door characteristic is null");
      return;
    }

    final message = "x";
    AppLogger.ble("Writing door command: $message");

    await doorCharacteristic!.write(
      message.codeUnits,
      withoutResponse: false,
    );

  } catch (e) {
    AppLogger.error("Door write failed", e);
  }
}
BluetoothCharacteristic? doorCharacteristic;
