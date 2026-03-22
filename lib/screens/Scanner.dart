import 'package:controller_app/services/DeviceStorage.dart';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:controller_app/all_IDs/MacAddress.dart';
import 'package:controller_app/screens/Door.dart';
import 'package:controller_app/screens/Tankk.dart';
import 'package:controller_app/services/Permissions.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  List<ScanResult> scanResults = [];
  List<String> savedDevices = [];

  
  void isTank(BuildContext context, ScanResult result) {
      if (result.device.remoteId == tankID) {
        print("Device is: ${result.device}");
        savedDevices.add(result.device.remoteId.toString() + " : Tankk");
      }
    }
  void isDoor(BuildContext context, ScanResult result) {
    if (result.device.remoteId == doorID) {
      print("Device is: ${result.device}");
      savedDevices.add(result.device.remoteId.toString() + " : Door");
    }
    
    }
  


  @override
  void initState() {
    super.initState();
    startScan();
  }

  void startScan() async {
    FlutterBluePlus.scanResults.listen((results) {
      debugPrint("Scan results count: ${results.length}");
      setState(() {
        scanResults = results;
      });
    });

  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await requestPermissions();
          await FlutterBluePlus.startScan(timeout: const Duration(seconds: 4));
        },
        backgroundColor: Colors.blue,
        mini: true,
        child: const Icon(Icons.search),
      ),

      appBar: AppBar(title: Text("Discover Devices"), foregroundColor: Colors.black, centerTitle: true,),
      body: ListView.builder(
        itemCount: scanResults.length,
        itemBuilder: (context, index) {
          final result = scanResults[index];
          return ListTile(
            title: Text(
              (result.device.platformName).isNotEmpty
                  ? (result.device.platformName)
                  : 'Unknown Device',
            ),
            subtitle: Text(result.device.remoteId.toString()),
            onTap: () async {
              try {
                await result.device.connect();
              } catch (e) {
                debugPrint('Connect error: $e');
              }

              final deviceName = (result.advertisementData.advName?.isNotEmpty ?? false)
                  ? result.advertisementData.advName!
                  : ((result.device.platformName).isNotEmpty ? result.device.platformName! : 'Unknown Device');

              final entry = '${result.device.remoteId } : $deviceName';

              final existing = await DeviceStorage.loadDevices();
              if (!existing.contains(entry)) {
                await DeviceStorage.saveDevices([...existing, entry]);
              }

              isTank(context, result);
              isDoor(context, result);
            },
            textColor: Colors.black,

          );
        },
      ),
    );
  }
}
