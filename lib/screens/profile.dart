import 'package:flutter/material.dart';
import '../utils/theme.dart';
import '../widgets/cyber_card.dart';

class ProfileScreen extends StatefulWidget { const ProfileScreen({super.key}); @override State<ProfileScreen> createState() => _ProfileScreenState(); }
class _ProfileScreenState extends State<ProfileScreen> {
  int _style = 0; bool _droneDemo = false; final _styles = const ['NEON RUNNER', 'PURPLE GHOST', 'URBAN GREEN'];
  @override Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(16), children: [
    const Text('PROFILE // OPERATOR', style: TextStyle(fontSize: 21, color: SentinelTheme.violet, fontWeight: FontWeight.bold)), const SizedBox(height: 16),
    CyberCard(title: 'IDENTITY', accent: SentinelTheme.violet, child: const ListTile(contentPadding: EdgeInsets.zero, leading: CircleAvatar(radius: 29, backgroundColor: SentinelTheme.violet, child: Icon(Icons.person, size: 38, color: SentinelTheme.background)), title: Text('SENTINEL OPERATOR'), subtitle: Text('City mode · connected'))),
    const SizedBox(height: 14), CyberCard(title: 'WARDROBE', accent: SentinelTheme.green, child: DropdownButton<int>(value: _style, isExpanded: true, items: List.generate(_styles.length, (i) => DropdownMenuItem(value: i, child: Text(_styles[i]))), onChanged: (value) => setState(() => _style = value ?? 0))),
    const SizedBox(height: 14), CyberCard(title: 'GARAGE // DRONE SIM', accent: SentinelTheme.cyan, child: SwitchListTile(contentPadding: EdgeInsets.zero, value: _droneDemo, onChanged: (v) => setState(() => _droneDemo = v), title: const Text('Тренировочный дрон'), subtitle: Text(_droneDemo ? 'Симуляция маршрута включена' : 'Режим ожидания'), secondary: const Icon(Icons.flight, color: SentinelTheme.cyan))),
  ]);
}
