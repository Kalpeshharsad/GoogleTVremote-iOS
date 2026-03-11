import 'dart:convert';
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pointycastle/export.dart';

class KeyService {
  static const String _publicKeyModulusKey = 'adb_public_key_modulus';
  static const String _publicKeyExponentKey = 'adb_public_key_exponent';
  static const String _privateKeyModulusKey = 'adb_private_key_modulus';
  static const String _privateKeyExponentKey = 'adb_private_key_exponent';
  static const String _privateKeyPKey = 'adb_private_key_p';
  static const String _privateKeyQKey = 'adb_private_key_q';

  static Future<AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey>?> loadKeys() async {
    final prefs = await SharedPreferences.getInstance();
    
    final pubMod = prefs.getString(_publicKeyModulusKey);
    final pubExp = prefs.getString(_publicKeyExponentKey);
    final privMod = prefs.getString(_privateKeyModulusKey);
    final privExp = prefs.getString(_privateKeyExponentKey);
    final privP = prefs.getString(_privateKeyPKey);
    final privQ = prefs.getString(_privateKeyQKey);

    if (pubMod == null || pubExp == null || privMod == null || privExp == null || privP == null || privQ == null) {
      return null;
    }

    final publicKey = RSAPublicKey(
      BigInt.parse(pubMod),
      BigInt.parse(pubExp),
    );

    final privateKey = RSAPrivateKey(
      BigInt.parse(privMod),
      BigInt.parse(privExp),
      BigInt.parse(privP),
      BigInt.parse(privQ),
    );

    return AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey>(publicKey, privateKey);
  }

  static Future<void> saveKeys(AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> keyPair) async {
    final prefs = await SharedPreferences.getInstance();
    
    await prefs.setString(_publicKeyModulusKey, keyPair.publicKey.modulus.toString());
    await prefs.setString(_publicKeyExponentKey, keyPair.publicKey.publicExponent.toString());
    await prefs.setString(_privateKeyModulusKey, keyPair.privateKey.modulus.toString());
    await prefs.setString(_privateKeyExponentKey, keyPair.privateKey.privateExponent.toString());
    await prefs.setString(_privateKeyPKey, keyPair.privateKey.p.toString());
    await prefs.setString(_privateKeyQKey, keyPair.privateKey.q.toString());
  }
}
