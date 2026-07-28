import 'package:flutter/material.dart';

import '../utils/theme.dart';
import '../widgets/cyber_card.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const contacts = [
      ('DEDSEC HQ', 'ONLINE', SentinelTheme.green),
      ('SITARA', 'AWAY', SentinelTheme.violet),
      ('JOSH', 'ONLINE', SentinelTheme.green),
      ('WRENCH', 'BUSY', Colors.orangeAccent),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('CONTACTS // CREW')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        const Text('ЛОКАЛЬНЫЙ СПИСОК', style: TextStyle(color: SentinelTheme.muted, fontSize: 12)),
        const SizedBox(height: 10),
        ...contacts.map((entry) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: CyberCard(
                title: entry.$1,
                accent: entry.$3,
                child: Row(children: [CircleAvatar(backgroundColor: entry.$3.withOpacity(.15), child: Icon(Icons.person_outline, color: entry.$3)), const SizedBox(width: 12), Expanded(child: Text(entry.$2, style: TextStyle(color: entry.$3, fontSize: 12))), const Icon(Icons.chat_bubble_outline, color: SentinelTheme.muted)]),
              ),
            )),
      ]),
    );
  }
}
