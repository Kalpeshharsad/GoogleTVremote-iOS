import 'package:shared_preferences/shared_preferences.dart';
import '../models/tv_device.dart';

class StorageService {
  static const String _savedTvsKey = 'saved_tvs';

  Future<List<TvDevice>> getSavedDevices() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? tvsJson = prefs.getStringList(_savedTvsKey);

    if (tvsJson == null) {
      return [];
    }

    return tvsJson.map((json) => TvDevice.fromJson(json)).toList()
      ..sort((a, b) {
        // Sort by most recently connected first
        final aTime = a.lastConnected ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bTime = b.lastConnected ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bTime.compareTo(aTime);
      });
  }

  Future<void> saveDevice(TvDevice device) async {
    final prefs = await SharedPreferences.getInstance();
    final List<TvDevice> currentDevices = await getSavedDevices();

    // Remove if it already exists to avoid duplicates
    currentDevices.removeWhere((d) => d.ipAddress == device.ipAddress);

    // Update the last connected time
    final updatedDevice = device.copyWith(lastConnected: DateTime.now());
    currentDevices.insert(0, updatedDevice);

    final List<String> tvsJson =
        currentDevices.map((d) => d.toJson()).toList();
    await prefs.setStringList(_savedTvsKey, tvsJson);
  }

  Future<void> removeDevice(String ipAddress) async {
    final prefs = await SharedPreferences.getInstance();
    final List<TvDevice> currentDevices = await getSavedDevices();

    currentDevices.removeWhere((d) => d.ipAddress == ipAddress);

    final List<String> tvsJson =
        currentDevices.map((d) => d.toJson()).toList();
    await prefs.setStringList(_savedTvsKey, tvsJson);
  }
}
