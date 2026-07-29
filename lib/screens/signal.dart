import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';

import '../utils/theme.dart';
import '../widgets/cyber_card.dart';
import '../widgets/glow_button.dart';
import '../widgets/neon_scaffold.dart';

class SignalScreen extends StatefulWidget {
  const SignalScreen({super.key});

  @override
  State<SignalScreen> createState() => _SignalScreenState();
}

class _SignalScreenState extends State<SignalScreen> {
  final _connectivity = Connectivity();
  final _network = NetworkInfo();
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  List<ConnectivityResult> _links = const [];
  String _ssid = '—';
  String _bssid = '—';
  String _ip = '—';
  String _gateway = '—';
  DateTime? _updatedAt;
  bool _busy = true;

  @override
  void initState() {
    super.initState();
    _subscription =
        _connectivity.onConnectivityChanged.listen((_) => _refresh());
    _refresh();
  }

  Future<void> _refresh() async {
    if (mounted) setState(() => _busy = true);
    try {
      final links = await _connectivity.checkConnectivity();
      final ssid = await _network.getWifiName();
      final bssid = await _network.getWifiBSSID();
      final ip = await _network.getWifiIP();
      final gateway = await _network.getWifiGatewayIP();
      if (!mounted) return;
      setState(() {
        _links = links;
        _ssid = ssid ?? '—';
        _bssid = bssid ?? '—';
        _ip = ip ?? '—';
        _gateway = gateway ?? '—';
        _updatedAt = DateTime.now();
      });
    } catch (error) {
      if (mounted) setState(() => _ssid = 'READ ERROR // $error');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  String get _linkLabel {
    if (_links.isEmpty || _links.contains(ConnectivityResult.none)) {
      return 'OFFLINE';
    }
    return _links.map((link) => link.name.toUpperCase()).join(' + ');
  }

  @override
  Widget build(BuildContext context) {
    final online =
        _links.isNotEmpty && !_links.contains(ConnectivityResult.none);
    return NeonScaffold(
      title: 'SIGNAL // WATCH',
      actions: [
        IconButton(onPressed: _refresh, icon: const Icon(Icons.sync)),
      ],
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CyberCard(
            title: 'CONNECTIVITY STREAM',
            accent: online ? SentinelTheme.green : SentinelTheme.magenta,
            pulse: true,
            child: Row(
              children: [
                Icon(
                  online ? Icons.cell_tower : Icons.signal_cellular_off,
                  size: 48,
                  color: online ? SentinelTheme.green : SentinelTheme.magenta,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    _busy ? 'REFRESHING...' : _linkLabel,
                    style: TextStyle(
                      color:
                          online ? SentinelTheme.green : SentinelTheme.magenta,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _SignalValue(label: 'WI-FI SSID', value: _ssid),
          const SizedBox(height: 9),
          _SignalValue(label: 'ACCESS POINT', value: _bssid),
          const SizedBox(height: 9),
          _SignalValue(label: 'LOCAL IP', value: _ip),
          const SizedBox(height: 9),
          _SignalValue(label: 'GATEWAY', value: _gateway),
          const SizedBox(height: 12),
          GlowButton(
            label: 'REFRESH LINK DATA',
            icon: Icons.refresh,
            color: SentinelTheme.cyan,
            onPressed: _busy ? null : _refresh,
          ),
          if (_updatedAt != null) ...[
            const SizedBox(height: 10),
            Text(
              'LAST UPDATE // ${_updatedAt!.toIso8601String()}',
              style: const TextStyle(
                color: SentinelTheme.muted,
                fontSize: 9,
              ),
            ),
          ],
          const SizedBox(height: 8),
          const Text(
            'Android сообщает тип подключения, но не гарантирует доступ в интернет. Для DNS-проверки используй PULSE.',
            style: TextStyle(color: SentinelTheme.muted, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class _SignalValue extends StatelessWidget {
  const _SignalValue({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return CyberCard(
      title: label,
      accent: SentinelTheme.cyan,
      padding: const EdgeInsets.all(12),
      child: SelectableText(
        value,
        style: const TextStyle(
          color: SentinelTheme.cyan,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
