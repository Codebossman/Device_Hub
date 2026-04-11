import 'dart:async';

import 'package:controller_app/services/DeviceStorage.dart';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:controller_app/all_IDs/MacAddress.dart';
import 'package:controller_app/screens/Door.dart';
import 'package:controller_app/screens/Tankk.dart';
import 'package:controller_app/services/Permissions.dart';
import 'package:controller_app/services/app_logger.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  List<ScanResult> scanResults = [];
  List<String> savedDevices = [];
  StreamSubscription<List<ScanResult>>? _scanSubscription;

  
  void isTank(BuildContext context, ScanResult result) {
      if (result.device.remoteId == tankID) {
        savedDevices.add(result.device.remoteId.toString() + " : Tankk");
      }
    }
  void isDoor(BuildContext context, ScanResult result) {
    if (result.device.remoteId == doorID) {
      savedDevices.add(result.device.remoteId.toString() + " : Door");
    }
    
    }
  


  @override
  void initState() {
    super.initState();
    startScan();
  }

  void startScan() async {
    _scanSubscription = FlutterBluePlus.scanResults.listen((results) {
      AppLogger.ble("Scanner results count: ${results.length}");
      if (!mounted) return;
      setState(() {
        scanResults = results;
      });
    });
  }

  @override
  void dispose() {
    _scanSubscription?.cancel();
    super.dispose();
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
                AppLogger.error('Connect error', e);
              }

              final deviceName = (result.advertisementData.advName?.isNotEmpty ?? false)
                  ? result.advertisementData.advName!
                  : ((result.device.platformName).isNotEmpty ? result.device.platformName! : 'Unknown Device');

              final entry = '${result.device.remoteId } : $deviceName';

              final existing = await DeviceStorage.getSavedDevices();
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
