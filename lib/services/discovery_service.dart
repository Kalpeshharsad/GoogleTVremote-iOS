import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:multicast_dns/multicast_dns.dart';
import '../models/tv_device.dart';

class DiscoveryService {
  MDnsClient? _client;
  final StreamController<List<TvDevice>> _devicesController = StreamController<List<TvDevice>>.broadcast();
  final List<TvDevice> _discoveredDevices = [];

  Stream<List<TvDevice>> get devicesStream => _devicesController.stream;

  void startDiscovery() async {
    _discoveredDevices.clear();
    _devicesController.add(_discoveredDevices);
    
    _client = MDnsClient();
    await _client?.start();

    // Scan for ADB service (common on Android TVs)
    const String name = '_adb._tcp.local';
    
    try {
      await for (final PtrResourceRecord ptr in _client!.lookup<PtrResourceRecord>(
          ResourceRecordQuery.serverPointer(name))) {
        
        await for (final SrvResourceRecord srv in _client!.lookup<SrvResourceRecord>(
            ResourceRecordQuery.service(ptr.domainName))) {
          
          await for (final IPAddressResourceRecord ip in _client!.lookup<IPAddressResourceRecord>(
              ResourceRecordQuery.addressIPv4(srv.target))) {
            
            // Try to extract a friendly name from the PTR domain name
            String deviceName = ptr.domainName.replaceAll('._adb._tcp.local', '');
            if (deviceName.isEmpty) {
               deviceName = 'Android TV';
            }

            final device = TvDevice(
              ipAddress: ip.address.address,
              name: deviceName,
            );

            if (!_discoveredDevices.any((d) => d.ipAddress == device.ipAddress)) {
              _discoveredDevices.add(device);
              _devicesController.add(_discoveredDevices);
            }
          }
        }
      }
    } catch (e) {
      debugPrint('mDNS Discovery Error: $e');
    }
  }

  void stopDiscovery() {
    _client?.stop();
    _client = null;
  }
}
