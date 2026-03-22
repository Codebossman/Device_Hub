import 'package:shared_preferences/shared_preferences.dart';
class DeviceStorage {
  static const String key = "saved_devices";

  static Future<void> saveDevices(List<String> devices) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key, devices);
  }

  static Future<List<String>> getSavedDevices() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key) ?? [];
  }
  static void removeAllDevices() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}