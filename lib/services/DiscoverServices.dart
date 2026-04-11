import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:controller_app/commands/DoorCommands.dart';
import 'package:controller_app/all_IDs/UUIDs.dart';
import 'package:controller_app/services/app_logger.dart';

Future<void> discoverServices(BluetoothDevice device) async {
  List<BluetoothService> services =
      await device.discoverServices();

  for (var service in services) {
    if (service.uuid == doorServiceUUID) {
      for (var characteristic in service.characteristics) {
        if (characteristic.uuid == doorCharacteristicUUID) {
          doorCharacteristic = characteristic;
        }
      }
    }
  }

  AppLogger.ble("Door characteristic found: $doorCharacteristic");
}
