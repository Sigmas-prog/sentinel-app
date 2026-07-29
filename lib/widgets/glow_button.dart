import 'package:flutter/material.dart';

import '../utils/theme.dart';

class GlowButton extends StatefulWidget {
  const GlowButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.color = SentinelTheme.cyan,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color color;

  @override
  State<GlowButton> createState() => _GlowButtonState();
}

class _GlowButtonState extends State<GlowButton> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (widget.onPressed == null) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;
    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapCancel: () => _setPressed(false),
      onTapUp: (_) => _setPressed(false),
      onTap: widget.onPressed,
      child: AnimatedScale(
        scale: _pressed ? 0.965 : 1,
        duration: const Duration(milliseconds: 90),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 110),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
          decoration: BoxDecoration(
            color: enabled
                ? widget.color.withValues(alpha: _pressed ? 0.22 : 0.1)
                : Colors.white.withValues(alpha: 0.03),
            border: Border.all(
              color: enabled ? widget.color : SentinelTheme.muted,
              width: _pressed ? 2 : 1,
            ),
            boxShadow: enabled
                ? [
                    BoxShadow(
                      color: widget.color.withValues(
                        alpha: _pressed ? 0.48 : 0.2,
                      ),
                      blurRadius: _pressed ? 18 : 9,
                    ),
                  ]
                : const [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, color: widget.color, size: 19),
                const SizedBox(width: 9),
              ],
              Flexible(
                child: Text(
                  widget.label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: enabled ? widget.color : SentinelTheme.muted,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
