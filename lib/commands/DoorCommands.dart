import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';


void sendDoorCommand() async {
  try {
    if (doorCharacteristic == null) {
      debugPrint("Characteristic is NULL");
      return;
    }

    final message = "x";
    debugPrint("Writing: $message");

    await doorCharacteristic!.write(
      message.codeUnits,
      withoutResponse: false,
    );

    debugPrint("Write successful");
  } catch (e) {
    debugPrint("WRITE ERROR: $e");
  }
}
BluetoothCharacteristic? doorCharacteristic;
