import 'package:flutter/material.dart';
import '../utils/theme.dart';
class GlowButton extends StatelessWidget {
  const GlowButton({super.key, required this.label, required this.onPressed, this.color = SentinelTheme.cyan, this.icon});
  final String label; final VoidCallback? onPressed; final Color color; final IconData? icon;
  @override Widget build(BuildContext context) => OutlinedButton.icon(
    onPressed: onPressed, icon: icon == null ? const SizedBox.shrink() : Icon(icon, size: 17),
    label: Text(label), style: OutlinedButton.styleFrom(foregroundColor: color, side: BorderSide(color: color), padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10)),
  );
}
