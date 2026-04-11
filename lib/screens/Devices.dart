import 'dart:async';

import 'package:flutter/material.dart';
import 'package:controller_app/services/DeviceStorage.dart';
import 'package:controller_app/MyWidgets/DeviceCard.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:controller_app/services/app_logger.dart';
class Devices extends StatefulWidget {
  @override
  State<Devices> createState() => _DevicesState();
}

class _DevicesState extends State<Devices> {
  late final StreamSubscription<List<ScanResult>> _scanSubscription;
  List<ScanResult> scanResults = [];

  @override
  void initState() {
    super.initState();
    _scanSubscription = FlutterBluePlus.scanResults.listen((results) {
      AppLogger.ble("Saved devices scan results count: ${results.length}");
      if (!mounted) return;
      setState(() {
        scanResults = results;
      });
    });
  }

  @override
  void dispose() {
    _scanSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Devices')),
      body: FutureBuilder<List<String>>(
        future: DeviceStorage.getSavedDevices(),
        builder: (context, snapshot) {
          // Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // Error state
          if (snapshot.hasError) {
            return Center(child: Text("Error loading devices"));
          }

          // Data ready
          final devices = snapshot.data ?? [];

          // Empty state
          if (devices.isEmpty) {
            return Center(child: Text("No devices saved"));
          }

          // Build your device list
          return ListView(
            children: devices.map((device) {
              final parts = device.split(" : ");
              final name = parts.length > 1 ? parts[1] : "Unknown";

              return Device(
                name: name,
                isOn: true,
                onTap: () {
                  AppLogger.ble("Tapped saved device: $name");
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
