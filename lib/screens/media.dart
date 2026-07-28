import 'dart:async';
import 'package:flutter/material.dart';
import '../utils/theme.dart';
import '../widgets/cyber_card.dart';

/// A local visual player. It deliberately plays no network audio.
class MediaScreen extends StatefulWidget { const MediaScreen({super.key}); @override State<MediaScreen> createState() => _MediaScreenState(); }
class _MediaScreenState extends State<MediaScreen> {
  Timer? _timer; bool _playing = false; double _progress = .14;
  void _toggle() { setState(() => _playing = !_playing); _timer?.cancel(); if (_playing) _timer = Timer.periodic(const Duration(milliseconds: 400), (_) { if (!mounted) return; setState(() => _progress = _progress >= 1 ? 0 : _progress + .012); }); }
  @override void dispose() { _timer?.cancel(); super.dispose(); }
  @override Widget build(BuildContext context) => Center(child: Padding(padding: const EdgeInsets.all(16), child: CyberCard(title: 'MEDIA // DEDSEC RADIO', accent: SentinelTheme.violet, child: Column(mainAxisSize: MainAxisSize.min, children: [
    const Icon(Icons.album, size: 116, color: SentinelTheme.violet), const SizedBox(height: 14), const Text('NEON UPLINK', style: TextStyle(fontSize: 22, color: SentinelTheme.cyan, letterSpacing: 1.3)), const Text('LOCAL VISUAL PLAYER', style: TextStyle(fontSize: 11, color: SentinelTheme.muted)),
    Slider(value: _progress, onChanged: (value) => setState(() => _progress = value), activeColor: SentinelTheme.green), IconButton(onPressed: _toggle, iconSize: 60, color: SentinelTheme.green, icon: Icon(_playing ? Icons.pause_circle : Icons.play_circle)),
  ]))));
}
