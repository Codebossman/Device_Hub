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
  
  
  

Widget isTank() {
  if (savedDevices.contains(tankID.toString() + " : Tankk")) {
    return Device(
      name: "Tankk",
      isOn: true,
      onTap: () {
        print("Tapped Tankk");
      },
    );
  } else {
    return Container();
  }
}
  Widget build(BuildContext context) {
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
