import 'package:flutter/material.dart';

import '../utils/theme.dart';

class CyberCard extends StatefulWidget {
  const CyberCard({
    super.key,
    required this.title,
    required this.child,
    this.accent = SentinelTheme.cyan,
    this.pulse = false,
    this.padding = const EdgeInsets.all(14),
  });

  final String title;
  final Widget child;
  final Color accent;
  final bool pulse;
  final EdgeInsets padding;

  @override
  State<CyberCard> createState() => _CyberCardState();
}

class _CyberCardState extends State<CyberCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  );

  @override
  void initState() {
    super.initState();
    if (widget.pulse) _pulse.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant CyberCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.pulse && !_pulse.isAnimating) {
      _pulse.repeat(reverse: true);
    } else if (!widget.pulse && _pulse.isAnimating) {
      _pulse.stop();
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulse,
      builder: (context, child) {
        final glow = widget.pulse ? 6 + (_pulse.value * 10) : 7.0;
        return Container(
          padding: widget.padding,
          decoration: BoxDecoration(
            color: SentinelTheme.panel,
            border: Border.all(
              color: widget.accent.withValues(
                alpha: widget.pulse ? 0.65 + _pulse.value * 0.35 : 0.6,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: widget.accent.withValues(alpha: 0.14),
                blurRadius: glow,
              ),
            ],
          ),
          child: child,
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 7, height: 7, color: widget.accent),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.title,
                  style: TextStyle(
                    color: widget.accent,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.4,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          widget.child,
        ],
      ),
    );
  }
}
