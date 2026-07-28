import 'package:flutter/material.dart';
import '../services/system_info.dart';
import '../utils/theme.dart';
import '../widgets/cyber_card.dart';
import '../widgets/glow_button.dart';
class DashboardScreen extends StatefulWidget { const DashboardScreen({super.key}); @override State<DashboardScreen> createState() => _DashboardScreenState(); }
class _DashboardScreenState extends State<DashboardScreen> {
  final _service = SystemInfoService(); late Future<SystemSnapshot> _snapshot;
  @override void initState() { super.initState(); _snapshot = _service.read(); }
  @override Widget build(BuildContext context) => RefreshIndicator(
    onRefresh: () async => setState(() => _snapshot = _service.read()),
    child: FutureBuilder<SystemSnapshot>(future: _snapshot, builder: (_, s) {
      if (s.hasError) return ListView(children: [Padding(padding: const EdgeInsets.all(20), child: Text('Ошибка данных: ${s.error}'))]);
      if (!s.hasData) return const Center(child: CircularProgressIndicator()); final d = s.data!;
      return ListView(padding: const EdgeInsets.all(16), children: [
        const Text('SENTINEL // DASHBOARD', style: TextStyle(fontSize: 21, color: SentinelTheme.cyan, fontWeight: FontWeight.bold)),
        const SizedBox(height: 5), const Text('диагностика устройства и сети'), const SizedBox(height: 18),
        CyberCard(title: 'УСТРОЙСТВО', child: _Rows(rows: {'MODEL': d.device, 'BATTERY': d.battery}), accent: SentinelTheme.violet),
        const SizedBox(height: 12), CyberCard(title: 'СЕТЬ', child: _Rows(rows: {'WI-FI': d.wifiName, 'IP': d.ip, 'MAC': d.mac}), accent: SentinelTheme.green),
        const SizedBox(height: 18), GlowButton(label: 'ОБНОВИТЬ ДАННЫЕ', icon: Icons.refresh, onPressed: () => setState(() => _snapshot = _service.read())),
      ]);
    }),
  );
}
class _Rows extends StatelessWidget { const _Rows({required this.rows}); final Map<String,String> rows;
 @override Widget build(BuildContext context) => Column(children: rows.entries.map((e) => Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [SizedBox(width: 94, child: Text(e.key, style: const TextStyle(color: SentinelTheme.muted, fontSize: 11))), Expanded(child: Text(e.value, style: const TextStyle(fontSize: 12)))]))).toList()); }
