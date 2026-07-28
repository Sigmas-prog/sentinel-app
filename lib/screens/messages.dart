import 'package:flutter/material.dart';
import '../utils/theme.dart';
import '../widgets/cyber_card.dart';

class MessagesScreen extends StatefulWidget { const MessagesScreen({super.key}); @override State<MessagesScreen> createState() => _MessagesScreenState(); }
class _MessagesScreenState extends State<MessagesScreen> {
  final _input = TextEditingController();
  final List<String> _notes = ['DEDSEC // Добро пожаловать в Sentinel.', 'SYSTEM // Локальные данные готовы.'];
  void _add() { final text = _input.text.trim(); if (text.isEmpty) return; setState(() { _notes.add('Я // $text'); _input.clear(); }); }
  @override void dispose() { _input.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('CHAT // NOTES', style: TextStyle(color: SentinelTheme.green)), backgroundColor: SentinelTheme.background), body: Column(children: [Expanded(child: ListView.builder(padding: const EdgeInsets.all(16), itemCount: _notes.length, itemBuilder: (_, i) => Padding(padding: const EdgeInsets.only(bottom: 10), child: CyberCard(title: i.isEven ? 'INBOX' : 'NOTE', accent: i.isEven ? SentinelTheme.green : SentinelTheme.cyan, child: Text(_notes[i]))))), Padding(padding: const EdgeInsets.all(14), child: TextField(controller: _input, onSubmitted: (_) => _add(), decoration: InputDecoration(hintText: 'Локальная заметка', suffixIcon: IconButton(icon: const Icon(Icons.send), onPressed: _add))))]));
}
