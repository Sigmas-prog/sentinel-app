import 'package:flutter/material.dart';
import '../utils/theme.dart';

class CyberCard extends StatelessWidget {
  const CyberCard({super.key, required this.title, required this.child, this.accent = SentinelTheme.cyan});
  final String title; final Widget child; final Color accent;
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: SentinelTheme.panel,
      border: Border.all(color: accent.withOpacity(.65)),
      borderRadius: BorderRadius.circular(7),
      boxShadow: [BoxShadow(color: accent.withOpacity(.1), blurRadius: 15)],
    ),
    padding: const EdgeInsets.all(14),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('// $title', style: TextStyle(color: accent, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
      const SizedBox(height: 12), child,
    ]),
  );
}
