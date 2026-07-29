import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../utils/theme.dart';
import '../widgets/cyber_card.dart';
import '../widgets/neon_scaffold.dart';

class SensorsScreen extends StatefulWidget {
  const SensorsScreen({super.key});

  @override
  State<SensorsScreen> createState() => _SensorsScreenState();
}

class _SensorsScreenState extends State<SensorsScreen> {
  final List<StreamSubscription<dynamic>> _subscriptions = [];
  AccelerometerEvent? _accelerometer;
  GyroscopeEvent? _gyroscope;
  MagnetometerEvent? _magnetometer;
  String? _error;

  @override
  void initState() {
    super.initState();
    _listen();
  }

  void _listen() {
    try {
      _subscriptions.add(
        accelerometerEventStream(
          samplingPeriod: SensorInterval.uiInterval,
        ).listen(
          (event) => mounted ? setState(() => _accelerometer = event) : null,
          onError: (Object error) =>
              mounted ? setState(() => _error = error.toString()) : null,
        ),
      );
      _subscriptions.add(
        gyroscopeEventStream(
          samplingPeriod: SensorInterval.uiInterval,
        ).listen(
          (event) => mounted ? setState(() => _gyroscope = event) : null,
          onError: (Object error) =>
              mounted ? setState(() => _error = error.toString()) : null,
        ),
      );
      _subscriptions.add(
        magnetometerEventStream(
          samplingPeriod: SensorInterval.uiInterval,
        ).listen(
          (event) => mounted ? setState(() => _magnetometer = event) : null,
          onError: (Object error) =>
              mounted ? setState(() => _error = error.toString()) : null,
        ),
      );
    } catch (error) {
      _error = error.toString();
    }
  }

  @override
  void dispose() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }

  String _vector(double? x, double? y, double? z) {
    if (x == null || y == null || z == null) return 'WAITING FOR SENSOR...';
    return 'X ${x.toStringAsFixed(3)}\n'
        'Y ${y.toStringAsFixed(3)}\n'
        'Z ${z.toStringAsFixed(3)}';
  }

  @override
  Widget build(BuildContext context) {
    return NeonScaffold(
      title: 'SENSORS // LIVE',
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_error != null)
            CyberCard(
              title: 'SENSOR ERROR',
              accent: SentinelTheme.magenta,
              child: Text(_error!),
            ),
          _SensorCard(
            title: 'ACCELEROMETER // m/s²',
            icon: Icons.speed,
            color: SentinelTheme.green,
            value: _vector(
              _accelerometer?.x,
              _accelerometer?.y,
              _accelerometer?.z,
            ),
          ),
          const SizedBox(height: 12),
          _SensorCard(
            title: 'GYROSCOPE // rad/s',
            icon: Icons.screen_rotation_alt,
            color: SentinelTheme.cyan,
            value: _vector(_gyroscope?.x, _gyroscope?.y, _gyroscope?.z),
          ),
          const SizedBox(height: 12),
          _SensorCard(
            title: 'MAGNETOMETER // µT',
            icon: Icons.explore,
            color: SentinelTheme.magenta,
            value: _vector(
              _magnetometer?.x,
              _magnetometer?.y,
              _magnetometer?.z,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Данные идут напрямую с датчиков телефона и обновляются в реальном времени.',
            style: TextStyle(color: SentinelTheme.muted, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class _SensorCard extends StatelessWidget {
  const _SensorCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.value,
  });

  final String title;
  final IconData icon;
  final Color color;
  final String value;

  @override
  Widget build(BuildContext context) {
    return CyberCard(
      title: title,
      accent: color,
      pulse: true,
      child: Row(
        children: [
          Icon(icon, color: color, size: 42),
          const SizedBox(width: 18),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                height: 1.7,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
