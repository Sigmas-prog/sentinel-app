import 'package:flutter/material.dart';

import '../utils/theme.dart';
import '../widgets/animated_grid.dart';
import 'city_map.dart';
import 'device_audit.dart';
import 'lens.dart';
import 'scanner.dart';
import 'terminal.dart';
import 'tools.dart';

class AppsHubScreen extends StatelessWidget {
  const AppsHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const modules = [
      _HubModule(
        label: 'NET',
        subtitle: 'WI-FI SCAN',
        icon: Icons.wifi_find,
        color: SentinelTheme.green,
        screen: ScannerScreen(),
      ),
      _HubModule(
        label: 'DEVICES',
        subtitle: 'LIVE STATUS',
        icon: Icons.memory,
        color: SentinelTheme.cyan,
        screen: DeviceAuditScreen(),
      ),
      _HubModule(
        label: 'LENS',
        subtitle: 'CAMERA',
        icon: Icons.center_focus_strong,
        color: SentinelTheme.magenta,
        screen: LensScreen(),
      ),
      _HubModule(
        label: 'CONSOLE',
        subtitle: 'SYSTEM CLI',
        icon: Icons.terminal,
        color: SentinelTheme.green,
        screen: TerminalScreen(),
      ),
      _HubModule(
        label: 'MAP',
        subtitle: 'OSM GRID',
        icon: Icons.public,
        color: SentinelTheme.cyan,
        screen: CityMapScreen(),
      ),
      _HubModule(
        label: 'TOOLS',
        subtitle: 'LOCAL LAB',
        icon: Icons.build_outlined,
        color: SentinelTheme.magenta,
        screen: ToolsScreen(),
      ),
    ];

    return PixelGridBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _StatusBar(),
                const SizedBox(height: 28),
                const Text(
                  'MARCUS // HUB',
                  style: TextStyle(
                    color: SentinelTheme.cyan,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.6,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'SENTINEL NODE 01  •  ONLINE',
                  style: TextStyle(
                    color: SentinelTheme.green,
                    fontSize: 10,
                    letterSpacing: 1.4,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: modules.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (context, index) => _HubTile(
                      module: modules[index],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(width: 8, height: 8, color: SentinelTheme.green),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'REAL DATA LINK // ROOT NOT REQUIRED',
                        style: TextStyle(
                          color: SentinelTheme.muted,
                          fontSize: 9,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusBar extends StatelessWidget {
  const _StatusBar();

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final time =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    return Row(
      children: [
        Text(
          time,
          style: const TextStyle(
            color: SentinelTheme.text,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        const Spacer(),
        const Icon(Icons.shield_outlined, size: 17, color: SentinelTheme.green),
        const SizedBox(width: 10),
        const Icon(Icons.signal_cellular_alt,
            size: 17, color: SentinelTheme.cyan),
        const SizedBox(width: 10),
        const Icon(Icons.battery_full, size: 17, color: SentinelTheme.green),
      ],
    );
  }
}

class _HubModule {
  const _HubModule({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.screen,
  });

  final String label;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Widget screen;
}

class _HubTile extends StatefulWidget {
  const _HubTile({required this.module});

  final _HubModule module;

  @override
  State<_HubTile> createState() => _HubTileState();
}

class _HubTileState extends State<_HubTile> with SingleTickerProviderStateMixin {
  bool _pressed = false;
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  void _open() {
    Navigator.of(context).push(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 260),
        pageBuilder: (context, animation, secondaryAnimation) =>
            widget.module.screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.97, end: 1).animate(animation),
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final module = widget.module;
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      onTap: _open,
      child: AnimatedScale(
        scale: _pressed ? 0.94 : 1,
        duration: const Duration(milliseconds: 100),
        child: AnimatedBuilder(
          animation: _pulse,
          builder: (context, child) => Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: SentinelTheme.panel,
              border: Border.all(
                color: module.color.withValues(
                  alpha: _pressed ? 1 : 0.55 + _pulse.value * 0.32,
                ),
                width: _pressed ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: module.color.withValues(
                    alpha: _pressed ? 0.5 : 0.12 + _pulse.value * 0.12,
                  ),
                  blurRadius: _pressed ? 22 : 9 + _pulse.value * 5,
                ),
              ],
            ),
            child: child,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(module.icon, color: module.color, size: 38),
                  Icon(Icons.open_in_new, color: module.color, size: 14),
                ],
              ),
              const Spacer(),
              Text(
                module.label,
                style: TextStyle(
                  color: module.color,
                  fontWeight: FontWeight.bold,
                  fontSize: module.label.length > 6 ? 13 : 16,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                module.subtitle,
                style: const TextStyle(
                  color: SentinelTheme.muted,
                  fontSize: 9,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
