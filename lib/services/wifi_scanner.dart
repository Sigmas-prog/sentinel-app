import 'package:permission_handler/permission_handler.dart';
import 'package:wifi_scan/wifi_scan.dart';

class WifiNetwork {
  const WifiNetwork({required this.ssid, required this.bssid, required this.level, required this.channel});
  final String ssid, bssid, level, channel;
}
class WifiScannerService {
  Future<List<WifiNetwork>> scan() async {
    final permission = await Permission.locationWhenInUse.request();
    if (!permission.isGranted) throw Exception('Нужно разрешение геолокации для поиска Wi-Fi.');
    final can = await WiFiScan.instance.canStartScan();
    if (can != CanStartScan.yes) throw Exception('Сканирование временно недоступно: $can');
    await WiFiScan.instance.startScan();
    final result = await WiFiScan.instance.getScannedResults();
    return result.map((e) => WifiNetwork(
      ssid: e.ssid.isEmpty ? '<скрытая сеть>' : e.ssid,
      bssid: e.bssid,
      level: '${e.level} dBm',
      channel: _channel(e.frequency),
    )).toList()..sort((a,b) => a.ssid.compareTo(b.ssid));
  }
  String _channel(int f) {
    if (f >= 2412 && f <= 2484) return f == 2484 ? '14' : '${(f - 2407) ~/ 5}';
    if (f >= 5000 && f <= 5900) return '${(f - 5000) ~/ 5}';
    return '—';
  }
}
