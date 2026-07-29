import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/theme.dart';
import '../widgets/cyber_card.dart';
import '../widgets/glow_button.dart';
import '../widgets/neon_scaffold.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  static const _storageKey = 'sentinel_notes_v1';
  final _controller = TextEditingController();
  List<_LocalNote> _notes = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_storageKey) ?? [];
    if (!mounted) return;
    setState(() {
      _notes = raw
          .map(
            (item) => _LocalNote.fromJson(
              jsonDecode(item) as Map<String, dynamic>,
            ),
          )
          .toList();
    });
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _storageKey,
      _notes.map((note) => jsonEncode(note.toJson())).toList(),
    );
  }

  Future<void> _add() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _notes.insert(0, _LocalNote(text: text, createdAt: DateTime.now()));
      _controller.clear();
    });
    await _persist();
  }

  Future<void> _remove(int index) async {
    setState(() => _notes.removeAt(index));
    await _persist();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NeonScaffold(
      title: 'NOTES // LOCAL',
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: CyberCard(
              title: 'NEW FIELD LOG',
              accent: SentinelTheme.cyan,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _controller,
                    minLines: 2,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'Запиши задачу или наблюдение',
                    ),
                    onSubmitted: (_) => _add(),
                  ),
                  const SizedBox(height: 10),
                  GlowButton(
                    label: 'SAVE LOG',
                    icon: Icons.add,
                    color: SentinelTheme.cyan,
                    onPressed: _add,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: _notes.isEmpty
                ? const Center(
                    child: Text(
                      'NO LOCAL LOGS',
                      style: TextStyle(color: SentinelTheme.muted),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                    itemCount: _notes.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final note = _notes[index];
                      return CyberCard(
                        title: _formatTime(note.createdAt),
                        accent: index.isEven
                            ? SentinelTheme.green
                            : SentinelTheme.magenta,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: SelectableText(
                                note.text,
                                style: const TextStyle(
                                  color: SentinelTheme.text,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () => _remove(index),
                              icon: const Icon(
                                Icons.close,
                                color: SentinelTheme.magenta,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime date) {
    String two(int value) => value.toString().padLeft(2, '0');
    return '${two(date.day)}.${two(date.month)}.${date.year} // '
        '${two(date.hour)}:${two(date.minute)}';
  }
}

class _LocalNote {
  const _LocalNote({required this.text, required this.createdAt});

  factory _LocalNote.fromJson(Map<String, dynamic> json) {
    return _LocalNote(
      text: json['text'] as String? ?? '',
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
    );
  }

  final String text;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => {
        'text': text,
        'createdAt': createdAt.toIso8601String(),
      };
}
