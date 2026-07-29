import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';

import '../utils/theme.dart';
import '../widgets/cyber_card.dart';
import '../widgets/glow_button.dart';
import '../widgets/neon_scaffold.dart';

class PulseScreen extends StatefulWidget {
  const PulseScreen({super.key});

  @override
  State<PulseScreen> createState() => _PulseScreenState();
}

class _PulseScreenState extends State<PulseScreen>
    with SingleTickerProviderStateMixin {
  final _host = TextEditingController(text: 'ubisoft.com');
  final _network = NetworkInfo();
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat(reverse: true);

  bool _running = false;
  String _status = 'READY';
  String _latency = '—';
  String _addresses = '—';
  String _localIp = '—';
  String _gateway = '—';

  Future<void> _run() async {
    if (_running) return;
    final host = _host.text.trim();
    if (!RegExp(r'^[a-zA-Z0-9.-]{1,253}$').hasMatch(host)) {
      setState(() => _status = 'INVALID HOST');
      return;
    }
    setState(() {
      _running = true;
      _status = 'PROBING...';
    });

    try {
      final local = await Future.wait([
        _network.getWifiIP(),
        _network.getWifiGatewayIP(),
      ]);
      final watch = Stopwatch()..start();
      final resolved =
          await InternetAddress.lookup(host).timeout(const Duration(seconds: 8));
      watch.stop();
      if (!mounted) return;
      setState(() {
        _localIp = local[0] ?? '—';
        _gateway = local[1] ?? '—';
        _latency = '${watch.elapsedMilliseconds} ms';
        _addresses = resolved.map((item) => item.address).take(4).join('\n');
        _status = resolved.isEmpty ? 'NO ADDRESS' : 'LINK ONLINE';
      });
    } on TimeoutException {
      if (mounted) setState(() => _status = 'DNS TIMEOUT');
    } on SocketException catch (error) {
      if (mounted) setState(() => _status = 'LINK ERROR // ${error.message}');
    } finally {
      if (mounted) setState(() => _running = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _run();
  }

  @override
  void dispose() {
    _host.dispose();
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NeonScaffold(
      title: 'PULSE // LINK',
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AnimatedBuilder(
            animation: _pulse,
            builder: (context, child) => CyberCard(
              title: 'NETWORK HEARTBEAT',
              accent: _status == 'LINK ONLINE'
                  ? SentinelTheme.green
                  : SentinelTheme.magenta,
              child: child!,
            ),
            child: Row(
              children: [
                AnimatedBuilder(
                  animation: _pulse,
                  builder: (context, child) => Transform.scale(
                    scale: 0.86 + _pulse.value * 0.2,
                    child: child,
                  ),
                  child: const Icon(
                    Icons.monitor_heart,
                    size: 45,
                    color: SentinelTheme.green,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    _status,
                    style: const TextStyle(
                      color: SentinelTheme.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          CyberCard(
            title: 'DNS PROBE',
            accent: SentinelTheme.cyan,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _host,
                  autocorrect: false,
                  keyboardType: TextInputType.url,
                  style: const TextStyle(color: SentinelTheme.text),
                  decoration: const InputDecoration(
                    labelText: 'HOST',
                    hintText: 'example.com',
                  ),
                  onSubmitted: (_) => _run(),
                ),
                const SizedBox(height: 12),
                GlowButton(
                  label: _running ? 'PROBING...' : 'RUN LINK TEST',
                  icon: Icons.radar,
                  color: SentinelTheme.cyan,
                  onPressed: _running ? null : _run,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _ValueCard(label: 'DNS RESPONSE', value: _latency),
          const SizedBox(height: 9),
          _ValueCard(label: 'RESOLVED ADDRESS', value: _addresses),
          const SizedBox(height: 9),
          _ValueCard(label: 'LOCAL IP', value: _localIp),
          const SizedBox(height: 9),
          _ValueCard(label: 'ROUTER GATEWAY', value: _gateway),
          const SizedBox(height: 12),
          const Text(
            'Проверка выполняет обычное разрешение DNS-имени. Она не сканирует чужие устройства и не обходит защиту.',
            style: TextStyle(color: SentinelTheme.muted, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class _ValueCard extends StatelessWidget {
  const _ValueCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return CyberCard(
      title: label,
      accent: SentinelTheme.green,
      padding: const EdgeInsets.all(12),
      child: SelectableText(
        value,
        style: const TextStyle(
          color: SentinelTheme.green,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
