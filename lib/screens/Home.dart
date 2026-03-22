import 'package:controller_app/MyWidgets/SideBarButton.dart';
import 'package:controller_app/all_IDs/MacAddress.dart';
import 'package:controller_app/screens/CheckStorage.dart';
import 'package:controller_app/screens/Devices.dart';
import 'package:controller_app/screens/Scanner.dart';
import 'package:controller_app/screens/Tankk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int selectedIndex = 0;
  bool sidebarOpen = true;

  final List<Widget> pages = [
    Devices(),
    ScanScreen(),
    Controller(device: BluetoothDevice(remoteId: tankID), onExit: () {}),
    CheckStorage()
    
  ];
  @override
  Widget build(BuildContext context) {
    if (selectedIndex == 2) {
      sidebarOpen = false;
    }

    return Scaffold(
      body: Row(
        children: [

          // SIDEBAR
AnimatedContainer(
  duration: const Duration(milliseconds: 200),
  width: sidebarOpen ? 150 : 70,

  child: SafeArea(
    child: ListView(
      children: [

        const SizedBox(height: 20),

        IconButton(
          icon: Icon(
            sidebarOpen
                ? Icons.arrow_back
                : Icons.arrow_forward,
          ),
          onPressed: () {
            setState(() {
              sidebarOpen = !sidebarOpen;
            });
          },
        ),

        SideBarButton(
          icon: Icons.developer_board,
          label: "Devices",
          selected: selectedIndex == 0,
          showingLabel: sidebarOpen,
          onTap: () {
            setState(() {
              selectedIndex = 0;
            });
          },
        ),

        SideBarButton(
          icon: Icons.search,
          label: "Discover",
          selected: selectedIndex == 1,
          showingLabel: sidebarOpen,
          onTap: () {
            setState(() {
              selectedIndex = 1;
            });
          },
        ),

        SideBarButton(
          icon: Icons.keyboard,
          label: "Controller",
          selected: selectedIndex == 2,
          showingLabel: sidebarOpen,
          onTap: () {
            setState(() {
              selectedIndex = 2;
            });
          },
        ),
        SideBarButton(
          icon: Icons.storage,
          label: "Storage",
          selected: selectedIndex == 3,
          showingLabel: sidebarOpen,
          onTap: () {
            setState(() {
              selectedIndex = 3;
            });
          },
        ),
      ],
    ),
  ),
),
          // MAIN CONTENT
          Expanded(
            child: pages[selectedIndex],
          ),

        ],
      ),
    );
  }
}