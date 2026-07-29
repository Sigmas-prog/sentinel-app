import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../services/wifi_scanner.dart';
import '../utils/theme.dart';
import '../widgets/cyber_card.dart';
import '../widgets/glow_button.dart';
import '../widgets/neon_scaffold.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen>
    with SingleTickerProviderStateMixin {
  final _scanner = WifiScannerService();
  late final AnimationController _radar = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1150),
  );

  List<WifiNetwork> _networks = const [];
  bool _scanning = false;
  String _status = 'READY // TAP SCAN';

  @override
  void initState() {
    super.initState();
    _scan();
  }

  @override
  void dispose() {
    _radar.dispose();
    super.dispose();
  }

  Future<void> _scan() async {
    if (_scanning) return;
    setState(() {
      _scanning = true;
      _status = 'SEARCHING RADIO SPECTRUM...';
    });
    _radar.repeat();
    try {
      final result = await _scanner.scan();
      if (!mounted) return;
      setState(() {
        _networks = result;
        _status = 'SCAN COMPLETE // ${result.length} NETWORKS';
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _status = 'SCAN ERROR // $error');
    } finally {
      _radar.stop();
      if (mounted) setState(() => _scanning = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return NeonScaffold(
      title: 'NET // WI-FI',
      actions: [
        IconButton(
          tooltip: 'Обновить',
          onPressed: _scanning ? null : _scan,
          icon: const Icon(Icons.refresh),
        ),
      ],
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
            child: CyberCard(
              title: 'RADIO SCANNER',
              accent: SentinelTheme.green,
              pulse: _scanning,
              child: Row(
                children: [
                  AnimatedBuilder(
                    animation: _radar,
                    builder: (context, child) => Transform.rotate(
                      angle: _radar.value * math.pi * 2,
                      child: child,
                    ),
                    child: const Icon(
                      Icons.wifi_find,
                      size: 44,
                      color: SentinelTheme.green,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      _status,
                      style: const TextStyle(
                        color: SentinelTheme.green,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: _networks.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        _status,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: SentinelTheme.muted),
                      ),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _scan,
                    color: SentinelTheme.green,
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                      itemCount: _networks.length,
                      itemBuilder: (context, index) {
                        final network = _networks[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 9),
                          child: _NetworkCard(network: network),
                        );
                      },
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: GlowButton(
              label: _scanning ? 'SCANNING...' : 'SCAN AGAIN',
              icon: Icons.radar,
              color: SentinelTheme.green,
              onPressed: _scanning ? null : _scan,
            ),
          ),
        ],
      ),
    );
  }
}

class _NetworkCard extends StatelessWidget {
  const _NetworkCard({required this.network});

  final WifiNetwork network;

  @override
  Widget build(BuildContext context) {
    final bars = network.level >= -50
        ? Icons.signal_wifi_4_bar
        : network.level >= -67
            ? Icons.network_wifi_3_bar
            : network.level >= -80
                ? Icons.network_wifi_2_bar
                : Icons.network_wifi_1_bar;
    return CyberCard(
      title: network.ssid,
      accent: network.level >= -67 ? SentinelTheme.cyan : SentinelTheme.magenta,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Icon(bars, color: SentinelTheme.green, size: 29),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'BSSID  ${network.bssid}',
                  style: const TextStyle(fontSize: 10),
                ),
                const SizedBox(height: 5),
                Text(
                  '${network.level} dBm  •  CH ${network.channel == 0 ? '—' : network.channel}  •  ${network.frequency} MHz',
                  style: const TextStyle(
                    color: SentinelTheme.green,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${network.quality}%',
            style: const TextStyle(
              color: SentinelTheme.cyan,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
