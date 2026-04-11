import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:controller_app/services/DiscoverServices.dart';
import 'package:controller_app/commands/DoorCommands.dart';
import 'package:controller_app/services/app_logger.dart';

class Door extends StatefulWidget {
  final BluetoothDevice device;

  const Door({super.key, required this.device});

  @override
  State<Door> createState() => _DoorState();
}

class _DoorState extends State<Door> {
  StreamSubscription<BluetoothConnectionState>? _connectionSubscription;

  @override
  void initState() {
    super.initState();
    discoverServices(widget.device);
    _connectionSubscription = widget.device.connectionState.listen((state) {
      AppLogger.ble("Door connection state: $state");
    });
  }

  @override
  void dispose() {
    _connectionSubscription?.cancel();
    super.dispose();
  }

  // we'll plug BLE write here next
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("title")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            sendDoorCommand();
          },
          child: const Text("Close door"),
        ),
      ),
    );
  }
}
