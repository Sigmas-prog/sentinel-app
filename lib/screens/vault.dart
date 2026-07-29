import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../utils/theme.dart';
import '../widgets/cyber_card.dart';
import '../widgets/glow_button.dart';
import '../widgets/neon_scaffold.dart';

class VaultScreen extends StatefulWidget {
  const VaultScreen({super.key});

  @override
  State<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends State<VaultScreen> {
  static const _storage = FlutterSecureStorage();
  static const _key = 'sentinel_vault_note';
  final _controller = TextEditingController();
  bool _hidden = true;
  bool _busy = true;
  String _status = 'OPENING KEYSTORE...';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      _controller.text = await _storage.read(key: _key) ?? '';
      _status = _controller.text.isEmpty ? 'VAULT EMPTY' : 'SECRET LOADED';
    } catch (error) {
      _status = 'KEYSTORE ERROR // $error';
    }
    if (mounted) setState(() => _busy = false);
  }

  Future<void> _save() async {
    setState(() => _busy = true);
    try {
      await _storage.write(key: _key, value: _controller.text);
      _status = 'ENCRYPTED + SAVED';
    } catch (error) {
      _status = 'SAVE ERROR // $error';
    }
    if (mounted) setState(() => _busy = false);
  }

  Future<void> _wipe() async {
    await _storage.delete(key: _key);
    _controller.clear();
    if (mounted) setState(() => _status = 'VAULT WIPED');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NeonScaffold(
      title: 'VAULT // SECURE',
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CyberCard(
            title: 'ANDROID KEYSTORE',
            accent: SentinelTheme.green,
            pulse: true,
            child: Row(
              children: [
                const Icon(
                  Icons.security,
                  color: SentinelTheme.green,
                  size: 38,
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
            title: 'SECRET NOTE',
            accent: SentinelTheme.magenta,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _controller,
                  obscureText: _hidden,
                  minLines: 4,
                  maxLines: 8,
                  decoration: InputDecoration(
                    hintText: 'Локальная секретная запись',
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => _hidden = !_hidden),
                      icon: Icon(
                        _hidden ? Icons.visibility : Icons.visibility_off,
                        color: SentinelTheme.magenta,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                GlowButton(
                  label: _busy ? 'WORKING...' : 'ENCRYPT + SAVE',
                  icon: Icons.lock,
                  color: SentinelTheme.green,
                  onPressed: _busy ? null : _save,
                ),
                const SizedBox(height: 10),
                GlowButton(
                  label: 'WIPE VAULT',
                  icon: Icons.delete_forever,
                  color: SentinelTheme.magenta,
                  onPressed: _wipe,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Запись хранится локально через защищённое хранилище Android. Sentinel не отправляет её в сеть.',
            style: TextStyle(color: SentinelTheme.muted, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
