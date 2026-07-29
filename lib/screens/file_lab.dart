import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../utils/theme.dart';
import '../widgets/cyber_card.dart';
import '../widgets/glow_button.dart';
import '../widgets/neon_scaffold.dart';

class FileLabScreen extends StatefulWidget {
  const FileLabScreen({super.key});

  @override
  State<FileLabScreen> createState() => _FileLabScreenState();
}

class _FileLabScreenState extends State<FileLabScreen> {
  String _name = 'NO FILE';
  String _size = '—';
  String _hash = '—';
  String _preview = 'Select a file through Android system picker.';
  bool _busy = false;

  Future<void> _pick() async {
    setState(() => _busy = true);
    try {
      final result = await FilePicker.platform.pickFiles(
        withData: false,
        allowMultiple: false,
      );
      final selected = result?.files.single;
      if (selected == null) return;
      if (selected.path == null) {
        throw const FileSystemException('Android did not expose a readable copy');
      }
      var hash = 0x811C9DC5;
      var length = 0;
      final previewBytes = <int>[];
      await for (final chunk in File(selected.path!).openRead()) {
        length += chunk.length;
        for (final byte in chunk) {
          hash ^= byte;
          hash = (hash * 0x01000193) & 0xFFFFFFFF;
          if (previewBytes.length < 700) previewBytes.add(byte);
        }
      }
      final decoded = utf8.decode(previewBytes, allowMalformed: true);
      if (!mounted) return;
      setState(() {
        _name = selected.name;
        _size = _formatSize(length);
        _hash = hash.toRadixString(16).padLeft(8, '0').toUpperCase();
        _preview = decoded.replaceAll(RegExp(r'[\x00-\x08\x0B\x0C\x0E-\x1F]'), '·');
      });
    } catch (error) {
      if (mounted) setState(() => _preview = 'READ ERROR // $error');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String _formatSize(int bytes) {
    if (bytes >= 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
    if (bytes >= 1024) return '${(bytes / 1024).toStringAsFixed(2)} KB';
    return '$bytes B';
  }

  @override
  Widget build(BuildContext context) {
    return NeonScaffold(
      title: 'FILES // INSPECT',
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GlowButton(
            label: _busy ? 'READING...' : 'SELECT LOCAL FILE',
            icon: Icons.folder_open,
            color: SentinelTheme.green,
            onPressed: _busy ? null : _pick,
          ),
          const SizedBox(height: 14),
          CyberCard(
            title: 'FILE METADATA',
            accent: SentinelTheme.cyan,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Line(label: 'NAME', value: _name),
                _Line(label: 'SIZE', value: _size),
                _Line(label: 'FNV-1A', value: _hash),
              ],
            ),
          ),
          const SizedBox(height: 12),
          CyberCard(
            title: 'UTF-8 PREVIEW // FIRST 700 BYTES',
            accent: SentinelTheme.magenta,
            child: SelectableText(
              _preview,
              style: const TextStyle(
                color: SentinelTheme.green,
                fontSize: 10,
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Файл выбирается только через системный проводник Android. Sentinel не изменяет и не загружает его.',
            style: TextStyle(color: SentinelTheme.muted, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 75,
            child: Text(
              label,
              style: const TextStyle(
                color: SentinelTheme.muted,
                fontSize: 10,
              ),
            ),
          ),
          Expanded(
            child: SelectableText(
              value,
              style: const TextStyle(
                color: SentinelTheme.cyan,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
