import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

import '../utils/theme.dart';
import '../widgets/cyber_card.dart';
import '../widgets/glow_button.dart';

/// Reads only the Android device's current Wi-Fi connection details.
/// It never probes, connects to, or controls another device.
class DeviceAuditScreen extends StatefulWidget {
  const DeviceAuditScreen({super.key});

  @override
  State<DeviceAuditScreen> createState() => _DeviceAuditScreenState();
}

class _DeviceAuditScreenState extends State<DeviceAuditScreen> {
  final _info = NetworkInfo();
  bool _loading = false;
  String _status = 'Нажми «ПРОВЕРИТЬ МОЮ СЕТЬ».';
  Map<String, String> _details = const {};

  Future<void> _audit() async {
    setState(() {
      _loading = true;
      _status = 'СЧИТЫВАЮ ПАРАМЕТРЫ ЭТОГО ТЕЛЕФОНА…';
    });
    try {
      final permission = await Permission.locationWhenInUse.request();
      if (!permission.isGranted) {
        throw Exception('Разреши геолокацию: Android требует её, чтобы показать имя Wi-Fi сети.');
      }
      final values = await Future.wait<String?>([
        _info.getWifiName(),
        _info.getWifiBSSID(),
        _info.getWifiIP(),
        _info.getWifiGatewayIP(),
        _info.getWifiSubmask(),
      ]);
      if (!mounted) return;
      setState(() {
        _details = {
          'СЕТЬ': _clean(values[0], '<не определена>'),
          'ТОЧКА ДОСТУПА': _clean(values[1], '<не определена>'),
          'IP ТЕЛЕФОНА': _clean(values[2], '<не определён>'),
          'ШЛЮЗ РОУТЕРА': _clean(values[3], '<не определён>'),
          'МАСКА СЕТИ': _clean(values[4], '<не определена>'),
        };
        _status = 'ГОТОВО // ВИДНА ТОЛЬКО ТЕКУЩАЯ СЕТЬ ТЕЛЕФОНА';
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _status = 'НЕ УДАЛОСЬ: ' + error.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _clean(String? value, String fallback) {
    if (value == null || value.isEmpty) return fallback;
    return value.replaceAll('"', '');
  }

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('МОИ УСТРОЙСТВА', style: TextStyle(fontSize: 21, color: SentinelTheme.green, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          const Text('Аудит только текущего телефона и Wi-Fi сети.'),
          const SizedBox(height: 16),
          GlowButton(
            label: _loading ? 'ПРОВЕРЯЮ…' : 'ПРОВЕРИТЬ МОЮ СЕТЬ',
            color: SentinelTheme.green,
            icon: Icons.shield_outlined,
            onPressed: _loading ? () {} : _audit,
          ),
          const SizedBox(height: 14),
          CyberCard(
            title: 'NETWORK ID',
            accent: SentinelTheme.cyan,
            child: _details.isEmpty
                ? Text(_status, style: const TextStyle(color: SentinelTheme.cyan, fontSize: 12))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ..._details.entries.map((item) => Padding(
                            padding: const EdgeInsets.only(bottom: 9),
                            child: Text(item.key + '\n' + item.value, style: const TextStyle(fontSize: 12, color: SentinelTheme.cyan)),
                          )),
                      Text(_status, style: const TextStyle(color: SentinelTheme.green, fontSize: 10)),
                    ],
                  ),
          ),
          const SizedBox(height: 14),
          const CyberCard(
            title: 'ROUTER DEFENSE CHECK',
            accent: SentinelTheme.violet,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _CheckLine('Поставь уникальный пароль администратора роутера.'),
              _CheckLine('Включи WPA2/WPA3 и отключи WPS.'),
              _CheckLine('Установи обновление прошивки роутера.'),
              _CheckLine('Не открывай удалённое управление роутером из интернета.'),
            ]),
          ),
          const SizedBox(height: 14),
          const Text('Sentinel не перебирает пароли, не обходит защиту и не управляет чужими устройствами.', style: TextStyle(color: SentinelTheme.muted, fontSize: 11)),
        ],
      );
}

class _CheckLine extends StatelessWidget {
  const _CheckLine(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Icon(Icons.check_circle_outline, color: SentinelTheme.green, size: 17),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 12))),
        ]),
      );
}
