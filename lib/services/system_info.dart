import 'dart:io';

import 'package:battery_plus/battery_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:network_info_plus/network_info_plus.dart';

class SystemSnapshot {
  const SystemSnapshot({
    required this.device,
    required this.android,
    required this.battery,
    required this.batteryState,
    required this.ssid,
    required this.ip,
    required this.gateway,
    required this.submask,
  });

  final String device;
  final String android;
  final int battery;
  final String batteryState;
  final String ssid;
  final String ip;
  final String gateway;
  final String submask;
}

class SystemInfoService {
  SystemInfoService({
    DeviceInfoPlugin? deviceInfo,
    Battery? battery,
    NetworkInfo? network,
  })  : _deviceInfo = deviceInfo ?? DeviceInfoPlugin(),
        _battery = battery ?? Battery(),
        _network = network ?? NetworkInfo();

  final DeviceInfoPlugin _deviceInfo;
  final Battery _battery;
  final NetworkInfo _network;

  Future<SystemSnapshot> read() async {
    var device = Platform.operatingSystem;
    var android = Platform.operatingSystemVersion;

    if (Platform.isAndroid) {
      final info = await _deviceInfo.androidInfo;
      device = '${info.manufacturer} ${info.model}'.trim();
      android = 'Android ${info.version.release} / API ${info.version.sdkInt}';
    } else if (Platform.isIOS) {
      final info = await _deviceInfo.iosInfo;
      device = '${info.name} ${info.model}';
      android = info.systemVersion;
    }

    final values = await Future.wait<Object?>([
      _battery.batteryLevel,
      _battery.batteryState,
      _network.getWifiName(),
      _network.getWifiIP(),
      _network.getWifiGatewayIP(),
      _network.getWifiSubmask(),
    ]);

    return SystemSnapshot(
      device: device,
      android: android,
      battery: values[0] as int,
      batteryState: _batteryLabel(values[1] as BatteryState),
      ssid: _clean(values[2] as String?, 'NOT CONNECTED'),
      ip: _clean(values[3] as String?, '—'),
      gateway: _clean(values[4] as String?, '—'),
      submask: _clean(values[5] as String?, '—'),
    );
  }

  String _clean(String? value, String fallback) {
    if (value == null || value.trim().isEmpty) return fallback;
    return value.replaceAll('"', '');
  }

  String _batteryLabel(BatteryState state) {
    switch (state) {
      case BatteryState.charging:
        return 'CHARGING';
      case BatteryState.full:
        return 'FULL';
      case BatteryState.discharging:
        return 'DISCHARGING';
      case BatteryState.connectedNotCharging:
        return 'CONNECTED';
      case BatteryState.unknown:
        return 'UNKNOWN';
    }
  }
}
