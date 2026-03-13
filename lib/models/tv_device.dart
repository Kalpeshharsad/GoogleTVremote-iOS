import 'dart:convert';

class TvDevice {
  final String ipAddress;
  final String name;
  final DateTime? lastConnected;

  TvDevice({
    required this.ipAddress,
    required this.name,
    this.lastConnected,
  });

  TvDevice copyWith({
    String? ipAddress,
    String? name,
    DateTime? lastConnected,
  }) {
    return TvDevice(
      ipAddress: ipAddress ?? this.ipAddress,
      name: name ?? this.name,
      lastConnected: lastConnected ?? this.lastConnected,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ipAddress': ipAddress,
      'name': name,
      'lastConnected': lastConnected?.millisecondsSinceEpoch,
    };
  }

  factory TvDevice.fromMap(Map<String, dynamic> map) {
    return TvDevice(
      ipAddress: map['ipAddress'] ?? '',
      name: map['name'] ?? '',
      lastConnected: map['lastConnected'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['lastConnected'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TvDevice.fromJson(String source) =>
      TvDevice.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TvDevice &&
        other.ipAddress == ipAddress &&
        other.name == name;
  }

  @override
  int get hashCode => ipAddress.hashCode ^ name.hashCode;

  @override
  String toString() => 'TvDevice(ipAddress: $ipAddress, name: $name, lastConnected: $lastConnected)';
}
