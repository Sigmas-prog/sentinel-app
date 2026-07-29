import 'package:flutter/material.dart';

import '../services/terminal_service.dart';
import '../utils/theme.dart';
import '../widgets/neon_scaffold.dart';

class TerminalScreen extends StatefulWidget {
  const TerminalScreen({super.key});

  @override
  State<TerminalScreen> createState() => _TerminalScreenState();
}

class _TerminalScreenState extends State<TerminalScreen>
    with SingleTickerProviderStateMixin {
  final _input = TextEditingController();
  final _scroll = ScrollController();
  final _focus = FocusNode();
  final _service = TerminalService();
  final List<_TerminalLine> _lines = const [
    _TerminalLine('SENTINEL CONSOLE 2.0', SentinelTheme.cyan),
    _TerminalLine('ANDROID USER MODE // TYPE help', SentinelTheme.muted),
  ].toList();

  late final AnimationController _cursor = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 650),
  )..repeat(reverse: true);
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _focus.requestFocus());
  }

  Future<void> _run() async {
    final source = _input.text.trim();
    if (source.isEmpty || _busy) return;
    setState(() {
      _busy = true;
      _lines.add(_TerminalLine('sentinel\$ $source', SentinelTheme.green));
      _input.clear();
    });
    _scrollToBottom();

    final result = await _service.execute(source);
    if (!mounted) return;
    setState(() {
      if (result == '__CLEAR__') {
        _lines.clear();
      } else {
        _lines.add(_TerminalLine(result, SentinelTheme.text));
      }
      _busy = false;
    });
    _scrollToBottom();
    _focus.requestFocus();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    _focus.dispose();
    _cursor.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NeonScaffold(
      title: 'CONSOLE // USER',
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xF5000000),
            border: Border.all(color: SentinelTheme.green),
            boxShadow: [
              BoxShadow(
                color: SentinelTheme.green.withValues(alpha: 0.18),
                blurRadius: 14,
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                color: SentinelTheme.green.withValues(alpha: 0.1),
                child: Text(
                  _busy ? 'PROCESS RUNNING...' : 'PROCESS.RUN // READY',
                  style: const TextStyle(
                    color: SentinelTheme.green,
                    fontSize: 9,
                    letterSpacing: 1,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: _scroll,
                  padding: const EdgeInsets.all(11),
                  itemCount: _lines.length,
                  itemBuilder: (context, index) {
                    final line = _lines[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: SelectableText(
                        line.text,
                        style: TextStyle(
                          color: line.color,
                          fontFamily: 'SentinelMono',
                          fontSize: 11,
                          height: 1.35,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 5, 7, 7),
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Color(0x6600FF88)),
                  ),
                ),
                child: Row(
                  children: [
                    const Text(
                      '>',
                      style: TextStyle(
                        color: SentinelTheme.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _input,
                        focusNode: _focus,
                        enabled: !_busy,
                        onSubmitted: (_) => _run(),
                        style: const TextStyle(
                          color: SentinelTheme.green,
                          fontSize: 12,
                        ),
                        decoration: const InputDecoration(
                          isDense: true,
                          filled: false,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          hintText: 'help',
                        ),
                      ),
                    ),
                    FadeTransition(
                      opacity: _cursor,
                      child: Container(
                        width: 8,
                        height: 16,
                        color: SentinelTheme.green,
                      ),
                    ),
                    IconButton(
                      onPressed: _busy ? null : _run,
                      icon: const Icon(
                        Icons.keyboard_return,
                        color: SentinelTheme.green,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TerminalLine {
  const _TerminalLine(this.text, this.color);

  final String text;
  final Color color;
}
