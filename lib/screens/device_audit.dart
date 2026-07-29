import 'dart:async';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../services/system_info.dart';
import '../utils/theme.dart';
import '../widgets/cyber_card.dart';
import '../widgets/neon_scaffold.dart';

class DeviceAuditScreen extends StatefulWidget {
  const DeviceAuditScreen({super.key});

  @override
  State<DeviceAuditScreen> createState() => _DeviceAuditScreenState();
}

class _DeviceAuditScreenState extends State<DeviceAuditScreen> {
  final _service = SystemInfoService();
  Timer? _timer;
  SystemSnapshot? _snapshot;
  String? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    await Permission.locationWhenInUse.request();
    await _refresh();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) => _refresh());
  }

  Future<void> _refresh() async {
    try {
      final snapshot = await _service.read();
      if (!mounted) return;
      setState(() {
        _snapshot = snapshot;
        _error = null;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error.toString();
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = _snapshot;
    return NeonScaffold(
      title: 'DEVICES // LIVE',
      actions: [
        IconButton(
          onPressed: _refresh,
          tooltip: 'Обновить',
          icon: const Icon(Icons.sync),
        ),
      ],
      child: _loading
          ? const Center(
              child: CircularProgressIndicator(color: SentinelTheme.cyan),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Row(
                  children: [
                    Container(width: 8, height: 8, color: SentinelTheme.green),
                    const SizedBox(width: 8),
                    const Text(
                      'AUTO REFRESH // 5 SEC',
                      style: TextStyle(
                        color: SentinelTheme.green,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  CyberCard(
                    title: 'READ ERROR',
                    accent: SentinelTheme.magenta,
                    child: Text(_error!),
                  ),
                ],
                if (snapshot != null) ...[
                  const SizedBox(height: 12),
                  _DataCard(
                    title: 'DEVICE',
                    icon: Icons.smartphone,
                    value: snapshot.device,
                    detail: snapshot.android,
                    color: SentinelTheme.cyan,
                  ),
                  const SizedBox(height: 10),
                  _DataCard(
                    title: 'BATTERY',
                    icon: snapshot.battery >= 90
                        ? Icons.battery_full
                        : Icons.battery_5_bar,
                    value: '${snapshot.battery}%',
                    detail: snapshot.batteryState,
                    color: snapshot.battery < 20
                        ? SentinelTheme.magenta
                        : SentinelTheme.green,
                  ),
                  const SizedBox(height: 10),
                  _DataCard(
                    title: 'WI-FI LINK',
                    icon: Icons.wifi,
                    value: snapshot.ssid,
                    detail: 'CURRENT ACCESS POINT',
                    color: SentinelTheme.magenta,
                  ),
                  const SizedBox(height: 10),
                  _NetworkGrid(snapshot: snapshot),
                ],
              ],
            ),
    );
  }
}

class _DataCard extends StatelessWidget {
  const _DataCard({
    required this.title,
    required this.icon,
    required this.value,
    required this.detail,
    required this.color,
  });

  final String title;
  final IconData icon;
  final String value;
  final String detail;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CyberCard(
      title: title,
      accent: color,
      child: Row(
        children: [
          Icon(icon, color: color, size: 34),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  detail,
                  style: const TextStyle(
                    color: SentinelTheme.muted,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NetworkGrid extends StatelessWidget {
  const _NetworkGrid({required this.snapshot});

  final SystemSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final values = {
      'IP ADDRESS': snapshot.ip,
      'GATEWAY': snapshot.gateway,
      'SUBNET MASK': snapshot.submask,
    };
    return CyberCard(
      title: 'NETWORK STACK',
      accent: SentinelTheme.green,
      pulse: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: values.entries
            .map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        entry.key,
                        style: const TextStyle(
                          color: SentinelTheme.muted,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    Text(
                      entry.value,
                      style: const TextStyle(
                        color: SentinelTheme.green,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
