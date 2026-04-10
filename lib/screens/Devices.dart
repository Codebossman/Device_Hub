import 'package:flutter/material.dart';
import 'package:controller_app/services/DeviceStorage.dart';
import 'package:controller_app/MyWidgets/DeviceCard.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
class Devices extends StatefulWidget {
  @override
  State<Devices> createState() => _DevicesState();
}

class _DevicesState extends State<Devices> {
  @override
  Widget build(BuildContext context) {
  List<ScanResult> scanResults = [];
  void startScan() async {
    FlutterBluePlus.scanResults.listen((results) {
      debugPrint("Scan results count: ${results.length}");
      setState(() {
        scanResults = results;
      });
    });

  }
  startScan();
  
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
                  print("Tapped $name");
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}