import 'dart:io';
import 'package:battery_plus/battery_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:network_info_plus/network_info_plus.dart';

class SystemSnapshot {
  const SystemSnapshot({required this.device, required this.ip, required this.wifiName, required this.battery, required this.mac});
  final String device, ip, wifiName, battery, mac;
}
class SystemInfoService {
  final _network = NetworkInfo(); final _battery = Battery();
  Future<SystemSnapshot> read() async {
    String device = Platform.operatingSystem;
    if (Platform.isAndroid) { final d = await DeviceInfoPlugin().androidInfo; device = '${d.manufacturer} ${d.model}'; }
    if (Platform.isIOS) { final d = await DeviceInfoPlugin().iosInfo; device = d.utsname.machine; }
    final level = await _battery.batteryLevel;
    final ip = await _network.getWifiIP() ?? 'нет Wi-Fi IP';
    final ssid = await _network.getWifiName() ?? 'не подключено';
    return SystemSnapshot(device: device, ip: ip, wifiName: ssid.replaceAll('"', ''), battery: '$level%', mac: 'недоступно в Android 10+');
  }
}
