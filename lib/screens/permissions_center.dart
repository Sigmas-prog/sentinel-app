import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../utils/theme.dart';
import '../widgets/cyber_card.dart';
import '../widgets/glow_button.dart';
import '../widgets/neon_scaffold.dart';

class PermissionsCenterScreen extends StatefulWidget {
  const PermissionsCenterScreen({super.key});

  @override
  State<PermissionsCenterScreen> createState() =>
      _PermissionsCenterScreenState();
}

class _PermissionsCenterScreenState extends State<PermissionsCenterScreen> {
  final Map<String, Permission> _permissions = {
    'CAMERA': Permission.camera,
    'LOCATION': Permission.locationWhenInUse,
    'NEARBY WI-FI': Permission.nearbyWifiDevices,
    'NOTIFICATIONS': Permission.notification,
  };
  Map<String, PermissionStatus> _statuses = {};
  bool _busy = true;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    if (mounted) setState(() => _busy = true);
    final next = <String, PermissionStatus>{};
    for (final entry in _permissions.entries) {
      try {
        next[entry.key] = await entry.value.status;
      } catch (_) {
        next[entry.key] = PermissionStatus.restricted;
      }
    }
    if (mounted) {
      setState(() {
        _statuses = next;
        _busy = false;
      });
    }
  }

  Future<void> _request(Permission permission) async {
    try {
      await permission.request();
    } finally {
      await _refresh();
    }
  }

  Color _color(PermissionStatus? status) {
    if (status?.isGranted == true || status?.isLimited == true) {
      return SentinelTheme.green;
    }
    if (status?.isPermanentlyDenied == true) return SentinelTheme.magenta;
    return SentinelTheme.warning;
  }

  String _label(PermissionStatus? status) {
    if (status == null) return 'CHECKING';
    if (status.isGranted) return 'GRANTED';
    if (status.isLimited) return 'LIMITED';
    if (status.isPermanentlyDenied) return 'DENIED // SETTINGS';
    if (status.isRestricted) return 'NOT AVAILABLE';
    return 'NOT GRANTED';
  }

  @override
  Widget build(BuildContext context) {
    return NeonScaffold(
      title: 'PERMISSIONS // CTRL',
      actions: [
        IconButton(onPressed: _refresh, icon: const Icon(Icons.sync)),
      ],
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CyberCard(
            title: 'ACCESS POLICY',
            accent: SentinelTheme.cyan,
            child: const Text(
              'Sentinel запрашивает доступ только после нажатия. Разрешения нужны камере, QR-сканеру, Wi-Fi и геолокации.',
            ),
          ),
          const SizedBox(height: 12),
          for (final entry in _permissions.entries) ...[
            CyberCard(
              title: entry.key,
              accent: _color(_statuses[entry.key]),
              child: Row(
                children: [
                  Icon(
                    _statuses[entry.key]?.isGranted == true
                        ? Icons.verified_user
                        : Icons.gpp_maybe,
                    color: _color(_statuses[entry.key]),
                    size: 34,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      _busy ? 'CHECKING...' : _label(_statuses[entry.key]),
                      style: TextStyle(
                        color: _color(_statuses[entry.key]),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed:
                        _busy ? null : () => _request(entry.value),
                    tooltip: 'Запросить',
                    icon: const Icon(
                      Icons.touch_app,
                      color: SentinelTheme.cyan,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
          GlowButton(
            label: 'OPEN ANDROID SETTINGS',
            icon: Icons.settings,
            color: SentinelTheme.magenta,
            onPressed: openAppSettings,
          ),
        ],
      ),
    );
  }
}
