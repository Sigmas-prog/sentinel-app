import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/theme.dart';
import '../widgets/cyber_card.dart';
import '../widgets/glow_button.dart';
import '../widgets/neon_scaffold.dart';

class ToolsScreen extends StatefulWidget {
  const ToolsScreen({super.key});

  @override
  State<ToolsScreen> createState() => _ToolsScreenState();
}

class _ToolsScreenState extends State<ToolsScreen> {
  final _password = TextEditingController();
  final _hashInput = TextEditingController();
  int _score = 0;
  String _hash = '00000000';
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    _restore();
  }

  Future<void> _restore() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _hashInput.text = prefs.getString('fnv_input') ?? '';
      _hash = prefs.getString('fnv_hash') ?? '00000000';
    });
  }

  void _checkPassword() {
    final value = _password.text;
    var score = 0;
    if (value.length >= 12) score++;
    if (RegExp(r'[a-zа-я]').hasMatch(value)) score++;
    if (RegExp(r'[A-ZА-Я]').hasMatch(value)) score++;
    if (RegExp(r'\d').hasMatch(value)) score++;
    if (RegExp(r'[^a-zA-Zа-яА-Я0-9]').hasMatch(value)) score++;
    setState(() => _score = score);
  }

  Future<void> _calculateHash() async {
    var hash = 0x811C9DC5;
    for (final byte in utf8.encode(_hashInput.text)) {
      hash ^= byte;
      hash = (hash * 0x01000193) & 0xFFFFFFFF;
    }
    final result = hash.toRadixString(16).padLeft(8, '0').toUpperCase();
    setState(() => _hash = result);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fnv_input', _hashInput.text);
    await prefs.setString('fnv_hash', result);
  }

  @override
  void dispose() {
    _password.dispose();
    _hashInput.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final label = _score >= 5
        ? 'STRONG'
        : _score >= 3
            ? 'MEDIUM'
            : 'WEAK';
    final scoreColor = _score >= 5
        ? SentinelTheme.green
        : _score >= 3
            ? SentinelTheme.warning
            : SentinelTheme.magenta;

    return NeonScaffold(
      title: 'TOOLS // LOCAL',
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CyberCard(
            title: 'PASSWORD LAB',
            accent: SentinelTheme.magenta,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _password,
                  obscureText: _obscure,
                  onChanged: (_) => _checkPassword(),
                  style: const TextStyle(color: SentinelTheme.text),
                  decoration: InputDecoration(
                    hintText: 'Введи пароль для локальной проверки',
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => _obscure = !_obscure),
                      icon: Icon(
                        _obscure ? Icons.visibility : Icons.visibility_off,
                        color: SentinelTheme.magenta,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 13),
                Row(
                  children: List.generate(
                    5,
                    (index) => Expanded(
                      child: Container(
                        height: 7,
                        margin: EdgeInsets.only(right: index == 4 ? 0 : 5),
                        color: index < _score
                            ? scoreColor
                            : SentinelTheme.muted.withValues(alpha: 0.2),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '$label // $_score OF 5',
                  style: TextStyle(
                    color: scoreColor,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 9),
                const Text(
                  'Проверяется: 12+ символов, нижний и верхний регистр, цифры, спецсимволы. Пароль никуда не отправляется и не сохраняется.',
                  style: TextStyle(color: SentinelTheme.muted, fontSize: 10),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          CyberCard(
            title: 'FNV-1A // 32 BIT',
            accent: SentinelTheme.cyan,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _hashInput,
                  minLines: 2,
                  maxLines: 4,
                  style: const TextStyle(color: SentinelTheme.text),
                  decoration: const InputDecoration(
                    hintText: 'Текст для вычисления хеша',
                  ),
                ),
                const SizedBox(height: 12),
                GlowButton(
                  label: 'CALCULATE HASH',
                  icon: Icons.fingerprint,
                  color: SentinelTheme.cyan,
                  onPressed: _calculateHash,
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(14),
                  color: Colors.black,
                  child: SelectableText(
                    '0x$_hash',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: SentinelTheme.green,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'FNV-1a — быстрый не криптографический хеш. Не используй его для хранения паролей.',
                  style: TextStyle(color: SentinelTheme.muted, fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
