import 'dart:async';

import 'package:flutter/material.dart';

import '../utils/theme.dart';
import '../widgets/cyber_card.dart';
import '../widgets/glow_button.dart';
import '../widgets/neon_scaffold.dart';

class TimeLabScreen extends StatefulWidget {
  const TimeLabScreen({super.key});

  @override
  State<TimeLabScreen> createState() => _TimeLabScreenState();
}

class _TimeLabScreenState extends State<TimeLabScreen> {
  Timer? _ticker;
  DateTime _now = DateTime.now();
  final Stopwatch _stopwatch = Stopwatch();
  int _countdown = 60;
  bool _countingDown = false;
  int _lastCountdownSecond = DateTime.now().second;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (!mounted) return;
      setState(() {
        _now = DateTime.now();
        if (_countingDown &&
            _countdown > 0 &&
            _now.second != _lastCountdownSecond) {
          _lastCountdownSecond = _now.second;
          _countdown--;
          if (_countdown == 0) _countingDown = false;
        }
      });
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  String _two(int value) => value.toString().padLeft(2, '0');

  String get _clock =>
      '${_two(_now.hour)}:${_two(_now.minute)}:${_two(_now.second)}';

  String get _date =>
      '${_two(_now.day)}.${_two(_now.month)}.${_now.year}';

  String get _elapsed {
    final value = _stopwatch.elapsed;
    final minutes = _two(value.inMinutes.remainder(60));
    final seconds = _two(value.inSeconds.remainder(60));
    final tenths = value.inMilliseconds.remainder(1000) ~/ 100;
    return '$minutes:$seconds.$tenths';
  }

  void _toggleStopwatch() {
    setState(() {
      if (_stopwatch.isRunning) {
        _stopwatch.stop();
      } else {
        _stopwatch.start();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return NeonScaffold(
      title: 'TIME // CONTROL',
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CyberCard(
            title: 'LOCAL DEVICE CLOCK',
            accent: SentinelTheme.cyan,
            pulse: true,
            child: Column(
              children: [
                Text(
                  _clock,
                  style: const TextStyle(
                    color: SentinelTheme.cyan,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3,
                  ),
                ),
                Text(
                  '$_date // ${_now.timeZoneName}',
                  style: const TextStyle(color: SentinelTheme.muted),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          CyberCard(
            title: 'STOPWATCH',
            accent: SentinelTheme.green,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  _elapsed,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: SentinelTheme.green,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: GlowButton(
                        label: _stopwatch.isRunning ? 'PAUSE' : 'START',
                        icon: _stopwatch.isRunning
                            ? Icons.pause
                            : Icons.play_arrow,
                        color: SentinelTheme.green,
                        onPressed: _toggleStopwatch,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GlowButton(
                        label: 'RESET',
                        icon: Icons.replay,
                        color: SentinelTheme.magenta,
                        onPressed: () => setState(() => _stopwatch.reset()),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          CyberCard(
            title: 'COUNTDOWN // 60 SEC',
            accent: SentinelTheme.magenta,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '$_countdown',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: SentinelTheme.magenta,
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                GlowButton(
                  label: _countingDown ? 'PAUSE TIMER' : 'START TIMER',
                  icon: Icons.hourglass_bottom,
                  color: SentinelTheme.magenta,
                  onPressed: () => setState(() {
                    _lastCountdownSecond = DateTime.now().second;
                    _countingDown = !_countingDown;
                  }),
                ),
                const SizedBox(height: 10),
                GlowButton(
                  label: 'RESET 60',
                  icon: Icons.restart_alt,
                  color: SentinelTheme.cyan,
                  onPressed: () => setState(() {
                    _countdown = 60;
                    _countingDown = false;
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
