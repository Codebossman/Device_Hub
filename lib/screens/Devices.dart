import 'package:controller_app/MyWidgets/DeviceCard.dart';
import 'package:controller_app/screens/Tankk.dart';
import 'package:controller_app/all_IDs/MacAddress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:controller_app/screens/Home.dart';
import 'package:controller_app/services/DeviceStorage.dart';

class Devices extends StatefulWidget {
  @override
  State<Devices> createState() => _DevicesState();
}

class _DevicesState extends State<Devices> {
  List<String> savedDevices = [];

@override
void initState() {
  super.initState();
  loadDevices();
}

void loadDevices() async {
  savedDevices = await DeviceStorage.getSavedDevices();
  setState(() {});
}
  
  
bool hasTank(List<String> devices) {
  return devices.any((device) {
    final parts = device.split(" : ");

    if (parts.length < 2) return false;

    final id = parts[0];
    final name = parts[1];

    return id == tankID.toString() && name == "Tankk";
  });
}  

Widget isTank() {
  return FutureBuilder<List<String>>(
    future: DeviceStorage.getSavedDevices(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return SizedBox();

      final devices = snapshot.data!;

      if (hasTank(devices)) {
        return Device(
          name: "Tankk",
          isOn: true,
          onTap: () {
            print("Tapped Tankk");
          },
        );
      }

      return SizedBox();
    },
  );
}
  Widget build(BuildContext context) {
    print("Saved devices: $savedDevices");
    return Scaffold(
      appBar: AppBar(title: Text('Devices')),
      body: Column(
        children: [
          Padding(padding: EdgeInsets.all(20)),
          isTank(),
          Device(
            name: "Fan",
            isOn: false,
            onTap: () {
              print("Tapped Fan");
            },
          ),
          Device(
            name: "TV",
            isOn: true,
            onTap: () {
              print("Tapped TV");
            },
          ),
        ],
      ),
    );
  }
}
