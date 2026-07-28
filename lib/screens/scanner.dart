import 'package:flutter/material.dart';
import '../services/wifi_scanner.dart';
import '../utils/theme.dart';
import '../widgets/cyber_card.dart';
import '../widgets/glow_button.dart';
class ScannerScreen extends StatefulWidget { const ScannerScreen({super.key}); @override State<ScannerScreen> createState() => _ScannerScreenState(); }
class _ScannerScreenState extends State<ScannerScreen> { final _scanner = WifiScannerService(); Future<List<WifiNetwork>>? _networks; String? _error;
 Future<void> _scan() async { setState(() { _error = null; _networks = _scanner.scan(); }); try { await _networks; } catch (e) { if (mounted) setState(() => _error = e.toString()); } }
 @override Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(16), children: [
  const Text('WI-FI // ОБЗОР', style: TextStyle(fontSize: 21, color: SentinelTheme.green, fontWeight: FontWeight.bold)), const SizedBox(height: 7), const Text('Локальная визуализация доступных сетей'), const SizedBox(height: 14),
  GlowButton(label: 'ЗАПУСТИТЬ СКАНИРОВАНИЕ', color: SentinelTheme.green, icon: Icons.wifi_find, onPressed: _scan), const SizedBox(height: 14),
  if (_error != null) CyberCard(title: 'СТАТУС', accent: Colors.orangeAccent, child: Text(_error!)),
  if (_networks != null) FutureBuilder<List<WifiNetwork>>(future: _networks, builder: (_, s) { if (s.connectionState != ConnectionState.done) return const Padding(padding: EdgeInsets.all(25), child: Center(child: CircularProgressIndicator())); if (!s.hasData) return const SizedBox(); final list = s.data!; return Column(children: [Text('НАЙДЕНО: ${list.length}', style: const TextStyle(color: SentinelTheme.muted)), const SizedBox(height: 10), ...list.map((n) => Padding(padding: const EdgeInsets.only(bottom: 9), child: CyberCard(title: n.ssid, accent: SentinelTheme.cyan, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('BSSID  ${n.bssid}'), Text('SIGNAL ${n.level}   CHANNEL ${n.channel}', style: const TextStyle(color: SentinelTheme.green, fontSize: 11))])))]); })
 ]); }
