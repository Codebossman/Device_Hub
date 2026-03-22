import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:controller_app/services/DiscoverServices.dart';
import 'package:controller_app/commands/DoorCommands.dart';

class Door extends StatefulWidget {
  final BluetoothDevice device;

  const Door({super.key, required this.device});

  @override
  State<Door> createState() => _DoorState();
}

class _DoorState extends State<Door> {
  @override
  void initState() {
    super.initState();
    discoverServices(widget.device);
    widget.device.connectionState.listen((state) {
      debugPrint("Connection state: $state");
    });
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
