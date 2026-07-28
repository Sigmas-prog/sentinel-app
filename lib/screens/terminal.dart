import 'package:flutter/material.dart';
import '../services/system_info.dart';
import '../services/terminal_service.dart';
import '../services/wifi_scanner.dart';
import '../utils/theme.dart';
class TerminalScreen extends StatefulWidget { const TerminalScreen({super.key}); @override State<TerminalScreen> createState() => _TerminalScreenState(); }
class _TerminalScreenState extends State<TerminalScreen> { final _input = TextEditingController(); final _service = TerminalService(SystemInfoService(), WifiScannerService()); final List<String> _lines = ['SENTINEL TERMINAL v1.0', 'Введите help для списка команд.']; bool _busy = false;
 Future<void> _run() async { final c = _input.text.trim(); if (c.isEmpty || _busy) return; setState(() { _busy=true; _lines.add('> $c'); _input.clear(); }); try { final out = await _service.execute(c); if (mounted) setState(() => _lines.add(out)); } catch(e) { if(mounted) setState(()=>_lines.add('Ошибка: $e')); } finally { if(mounted) setState(()=>_busy=false); } }
 @override void dispose(){_input.dispose();super.dispose();}
 @override
 Widget build(BuildContext context) => Column(children: [
   Expanded(
     child: Container(
       margin: const EdgeInsets.all(14),
       padding: const EdgeInsets.all(12),
       decoration: BoxDecoration(color: Colors.black.withOpacity(.72), border: Border.all(color: SentinelTheme.violet)),
       child: ListView(children: _lines.map((line) => Padding(
         padding: const EdgeInsets.only(bottom: 8),
         child: Text(line, style: const TextStyle(fontSize: 12, color: Color(0xFFD6F5FF))),
       )).toList()),
     ),
   ),
   Padding(
     padding: const EdgeInsets.fromLTRB(14, 0, 14, 16),
     child: TextField(
       controller: _input,
       enabled: !_busy,
       onSubmitted: (_) => _run(),
       style: const TextStyle(color: SentinelTheme.green),
       decoration: InputDecoration(prefixText: '> ', prefixStyle: const TextStyle(color: SentinelTheme.green), hintText: _busy ? 'выполняется...' : 'help', border: const OutlineInputBorder()),
     ),
   ),
 ]);
}
