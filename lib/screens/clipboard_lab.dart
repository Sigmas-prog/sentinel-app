import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/theme.dart';
import '../widgets/cyber_card.dart';
import '../widgets/glow_button.dart';
import '../widgets/neon_scaffold.dart';

class ClipboardLabScreen extends StatefulWidget {
  const ClipboardLabScreen({super.key});

  @override
  State<ClipboardLabScreen> createState() => _ClipboardLabScreenState();
}

class _ClipboardLabScreenState extends State<ClipboardLabScreen> {
  final _controller = TextEditingController();
  String _status = 'PRESS READ TO ACCESS CLIPBOARD';

  Future<void> _read() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final text = data?.text ?? '';
    _controller.text = text;
    setState(() => _status = text.isEmpty ? 'BUFFER EMPTY' : 'BUFFER READ');
  }

  Future<void> _write() async {
    await Clipboard.setData(ClipboardData(text: _controller.text));
    setState(() => _status = 'BUFFER UPDATED');
  }

  Future<void> _clear() async {
    await Clipboard.setData(const ClipboardData(text: ''));
    _controller.clear();
    setState(() => _status = 'BUFFER CLEARED');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = _controller.text;
    final words = text.trim().isEmpty
        ? 0
        : text.trim().split(RegExp(r'\s+')).length;
    final bytes = utf8.encode(text).length;
    return NeonScaffold(
      title: 'CLIPBOARD // LOCAL',
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CyberCard(
            title: 'PRIVACY STATUS',
            accent: SentinelTheme.green,
            child: Text(
              _status,
              style: const TextStyle(
                color: SentinelTheme.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          CyberCard(
            title: 'TEXT BUFFER',
            accent: SentinelTheme.magenta,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _controller,
                  minLines: 6,
                  maxLines: 12,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    hintText: 'Буфер читается только после кнопки READ',
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: GlowButton(
                        label: 'READ',
                        icon: Icons.content_paste,
                        color: SentinelTheme.cyan,
                        onPressed: _read,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GlowButton(
                        label: 'WRITE',
                        icon: Icons.copy_all,
                        color: SentinelTheme.green,
                        onPressed: _write,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                GlowButton(
                  label: 'CLEAR BUFFER',
                  icon: Icons.backspace_outlined,
                  color: SentinelTheme.magenta,
                  onPressed: _clear,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          CyberCard(
            title: 'BUFFER METRICS',
            accent: SentinelTheme.cyan,
            child: Text(
              'CHARS ${text.length}\nWORDS $words\nUTF-8 BYTES $bytes',
              style: const TextStyle(
                color: SentinelTheme.cyan,
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
