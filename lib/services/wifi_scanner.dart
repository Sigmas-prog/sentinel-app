import 'package:wifi_scan/wifi_scan.dart';

class WifiNetwork {
  const WifiNetwork({
    required this.ssid,
    required this.bssid,
    required this.level,
    required this.channel,
    required this.frequency,
  });

  final String ssid;
  final String bssid;
  final int level;
  final int channel;
  final int frequency;

  int get quality {
    if (level >= -50) return 100;
    if (level <= -100) return 0;
    return 2 * (level + 100);
  }
}

class WifiScannerService {
  Future<List<WifiNetwork>> scan() async {
    final canStart =
        await WiFiScan.instance.canStartScan(askPermissions: true);
    if (canStart != CanStartScan.yes) {
      throw WifiScanException(_startMessage(canStart));
    }

    await WiFiScan.instance.startScan();

    final canRead =
        await WiFiScan.instance.canGetScannedResults(askPermissions: true);
    if (canRead != CanGetScannedResults.yes) {
      throw WifiScanException(
        'Android не разрешил получить список сетей: $canRead. '
        'Включи Wi-Fi и геолокацию.',
      );
    }

    final accessPoints = await WiFiScan.instance.getScannedResults();
    final networks = accessPoints
        .map(
          (point) => WifiNetwork(
            ssid: point.ssid.trim().isEmpty ? '<HIDDEN>' : point.ssid,
            bssid: point.bssid,
            level: point.level,
            channel: channelFromFrequency(point.frequency),
            frequency: point.frequency,
          ),
        )
        .toList()
      ..sort((a, b) => b.level.compareTo(a.level));
    return networks;
  }

  static int channelFromFrequency(int frequency) {
    if (frequency == 2484) return 14;
    if (frequency >= 2412 && frequency <= 2472) {
      return (frequency - 2407) ~/ 5;
    }
    if (frequency >= 5000 && frequency <= 5895) {
      return (frequency - 5000) ~/ 5;
    }
    if (frequency >= 5955 && frequency <= 7115) {
      return (frequency - 5950) ~/ 5;
    }
    return 0;
  }

  String _startMessage(CanStartScan state) {
    return 'Сканирование недоступно: $state. Включи Wi-Fi и геолокацию, '
        'затем выдай Sentinel разрешение на поиск сетей.';
  }
}

class WifiScanException implements Exception {
  const WifiScanException(this.message);

  final String message;

  @override
  String toString() => message;
}
