import 'package:flutter/material.dart';
import 'package:controller_app/services/DeviceStorage.dart';

class CheckStorage extends StatefulWidget {
  @override
  _CheckStorageState createState() => _CheckStorageState();
}
class _CheckStorageState extends State<CheckStorage> {
  List<String> savedDevices = [];

  @override
  void initState() {
    super.initState();
    loadSavedDevices();
  }

  Future<void> loadSavedDevices() async {
    final devices = await DeviceStorage.getSavedDevices();
    setState(() {
      savedDevices = devices;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Saved Devices'), leading: IconButton(icon: Icon(Icons.garage), onPressed: () => DeviceStorage.key),),
      body: ListView.builder(
        itemCount: savedDevices.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(savedDevices[index]),
          );
        },
      ),
      
    );
  }
}