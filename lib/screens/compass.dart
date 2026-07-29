import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../utils/theme.dart';
import '../widgets/cyber_card.dart';
import '../widgets/neon_scaffold.dart';

class CompassScreen extends StatefulWidget {
  const CompassScreen({super.key});

  @override
  State<CompassScreen> createState() => _CompassScreenState();
}

class _CompassScreenState extends State<CompassScreen> {
  StreamSubscription<MagnetometerEvent>? _subscription;
  double? _heading;
  double _strength = 0;
  String? _error;

  @override
  void initState() {
    super.initState();
    _subscription = magnetometerEventStream(
      samplingPeriod: SensorInterval.uiInterval,
    ).listen(
      (event) {
        final radians = math.atan2(event.y, event.x);
        final heading = (radians * 180 / math.pi + 360) % 360;
        final strength =
            math.sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
        if (mounted) {
          setState(() {
            _heading = heading;
            _strength = strength;
          });
        }
      },
      onError: (Object error) =>
          mounted ? setState(() => _error = error.toString()) : null,
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  String get _direction {
    final value = _heading;
    if (value == null) return '—';
    const points = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
    return points[((value + 22.5) ~/ 45) % 8];
  }

  @override
  Widget build(BuildContext context) {
    final heading = _heading ?? 0;
    return NeonScaffold(
      title: 'COMPASS // MAG',
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_error != null)
            CyberCard(
              title: 'MAGNETOMETER ERROR',
              accent: SentinelTheme.magenta,
              child: Text(_error!),
            ),
          CyberCard(
            title: 'LIVE BEARING',
            accent: SentinelTheme.cyan,
            pulse: true,
            child: SizedBox(
              height: 280,
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 230,
                      height: 230,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: SentinelTheme.cyan,
                          width: 2,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x5500FFCC),
                            blurRadius: 24,
                          ),
                        ],
                      ),
                    ),
                    const Positioned(
                      top: 28,
                      child: Text(
                        'N',
                        style: TextStyle(
                          color: SentinelTheme.magenta,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Transform.rotate(
                      angle: -heading * math.pi / 180,
                      child: const Icon(
                        Icons.navigation,
                        size: 150,
                        color: SentinelTheme.green,
                      ),
                    ),
                    Positioned(
                      bottom: 5,
                      child: Text(
                        '${heading.toStringAsFixed(1)}°  $_direction',
                        style: const TextStyle(
                          color: SentinelTheme.cyan,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          CyberCard(
            title: 'FIELD STRENGTH',
            accent: SentinelTheme.green,
            child: Text(
              '${_strength.toStringAsFixed(1)} µT',
              style: const TextStyle(
                color: SentinelTheme.green,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Компас вычисляется по магнитометру. Для калибровки сделай телефоном несколько движений в форме восьмёрки.',
            style: TextStyle(color: SentinelTheme.muted, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
