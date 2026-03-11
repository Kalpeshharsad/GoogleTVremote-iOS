import 'dart:io';
import 'package:flutter_adb/adb_connection.dart';
import 'package:flutter_adb/adb_crypto.dart';
import 'package:flutter_adb/adb_stream.dart';
import 'key_service.dart';
import 'package:pointycastle/export.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class ADBService {
  AdbConnection? _connection;
  bool _isConnected = false;
  String? _fingerprint;

  bool get isConnected => _isConnected;
  String get fingerprint => _fingerprint ?? 'Pending...';

  Future<bool> connect(String ip, {int port = 5555}) async {
    try {
      // Load or generate keys
      var keyPair = await KeyService.loadKeys();
      if (keyPair == null) {
        keyPair = AdbCrypto.generateAdbKeyPair();
        await KeyService.saveKeys(keyPair);
        print('Generated and saved new ADB keys');
      } else {
        print('Loaded existing ADB keys');
      }

      final AdbCrypto crypto = AdbCrypto(keyPair: keyPair);
      _connection = AdbConnection(ip, port, crypto);
      
      // Update fingerprint
      _calculateFingerprint(crypto);
      print('Current Fingerprint: $_fingerprint');
      
      final bool connected = await _connection!.connect();
      
      if (connected) {
        _isConnected = true;
        print('Connected to $ip:$port');
        return true;
      }
    } catch (e) {
      print('Connection failed: $e');
      _isConnected = false;
    }
    return false;
  }

  void _calculateFingerprint(AdbCrypto crypto) {
    try {
      final payload = crypto.getAdbPublicKeyPayload();
      // ADB fingerprint is MD5 of the public key payload (usually the base64 part)
      // The payload is: base64(adb_pub_key) + " " + "unknown@unknown\0"
      // We want the MD5 of the raw adb_pub_key bytes if possible, 
      // but matching the UI's colon-separated format.
      
      // For simplicity in debugging stability, we'll just MD5 the whole payload
      // and format it as colon-separated hex.
      final hash = md5.convert(payload).bytes;
      _fingerprint = hash.map((e) => e.toRadixString(16).padLeft(2, '0').toUpperCase()).join(':');
    } catch (e) {
      _fingerprint = 'Error: $e';
    }
  }

  Future<void> disconnect() async {
    _connection = null;
    _isConnected = false;
  }

  Future<void> sendKeyEvent(int keyCode) async {
    if (!_isConnected || _connection == null) return;
    try {
      // Open a shell stream to send the command
      final AdbStream stream = await _connection!.openShell();
      await stream.writeString('input keyevent $keyCode\n');
      stream.close();
    } catch (e) {
      print('Failed to send key event: $e');
    }
  }

  // KeyCodes for Google TV
  static const int KEYCODE_UP = 19;
  static const int KEYCODE_DOWN = 20;
  static const int KEYCODE_LEFT = 21;
  static const int KEYCODE_RIGHT = 22;
  static const int KEYCODE_ENTER = 66;
  static const int KEYCODE_BACK = 4;
  static const int KEYCODE_HOME = 3;
  static const int KEYCODE_POWER = 26;
  static const int KEYCODE_VOLUME_UP = 24;
  static const int KEYCODE_VOLUME_DOWN = 25;
  static const int KEYCODE_MUTE = 164;
  static const int KEYCODE_MENU = 82;
  static const int KEYCODE_CHANNEL_UP = 166;
  static const int KEYCODE_CHANNEL_DOWN = 167;
}
