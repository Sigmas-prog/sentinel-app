import 'package:flutter/material.dart';

import '../utils/theme.dart';
import '../widgets/cyber_card.dart';
import 'contacts.dart';
import 'device_audit.dart';
import 'lens.dart';
import 'media.dart';
import 'messages.dart';
import 'profile.dart';
import 'hack_effect.dart';
import 'tools.dart';
import 'scanner.dart';

class AppsHubScreen extends StatelessWidget {
  const AppsHubScreen({super.key});

  void _open(BuildContext context, Widget screen) => Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));

  @override
  Widget build(BuildContext context) {
    final apps = <_AppItem>[
      _AppItem('NET', 'Сканер Wi-Fi', Icons.wifi_find, SentinelTheme.green, const ScannerScreen()),
      _AppItem('DEVICES', 'Мои устройства', Icons.devices_other_outlined, SentinelTheme.cyan, const DeviceAuditScreen()),
      _AppItem('LENS', 'Камера и кадры', Icons.camera_alt_outlined, SentinelTheme.cyan, const LensScreen()),
      _AppItem('MEDIA', 'Музыка', Icons.graphic_eq, SentinelTheme.violet, const MediaScreen()),
      _AppItem('CHAT', 'Заметки', Icons.forum_outlined, SentinelTheme.green, const MessagesScreen()),
      _AppItem('CONTACTS', 'Команда', Icons.people_outline, SentinelTheme.cyan, const ContactsScreen()),
      _AppItem('TOOLS', 'Мини‑инструменты', Icons.construction_outlined, Colors.orangeAccent, const ToolsScreen()),
      _AppItem('PROFILE', 'Профиль', Icons.person_outline, Colors.orangeAccent, const ProfileScreen()),
      _AppItem('VISUALS', 'Визуализация', Icons.hub_outlined, SentinelTheme.violet, const EffectScreen()),
    ];
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(children:[const Expanded(child:Text('DEDSEC // HOME', style: TextStyle(fontSize: 21, color: SentinelTheme.violet, fontWeight: FontWeight.bold))),Container(width:9,height:9,decoration:const BoxDecoration(color:SentinelTheme.green,shape:BoxShape.circle))]),
        const SizedBox(height: 6),
        const Text('MARCUS MODE  •  ONLINE  •  SAN FRANCISCO'),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: apps.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 1.05),
          itemBuilder: (_, index) {
            final app = apps[index];
            return InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () => _open(context, app.screen),
              child: CyberCard(title: app.title, accent: app.color, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(app.icon, color: app.color, size: 38), const Spacer(), Text(app.subtitle, style: const TextStyle(fontSize: 11, color: SentinelTheme.muted))])),
            );
          },
        ),
        const SizedBox(height: 16),
        CyberCard(title: 'SYSTEM', accent:SentinelTheme.green, child: const Text('SENTINEL OS  •  ЛИЧНЫЙ ТЕЛЕФОН  •  ВСЕ ПРОВЕРКИ ВЫПОЛНЯЮТСЯ ТОЛЬКО ДЛЯ ТВОЕГО УСТРОЙСТВА', style: TextStyle(fontSize: 11))),
      ],
    );
  }
}

class _AppItem {
  const _AppItem(this.title, this.subtitle, this.icon, this.color, this.screen);
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Widget screen;
}
