import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../utils/theme.dart';

/// Animated ctOS-inspired pixel grid used behind every Sentinel screen.
class PixelGridBackground extends StatefulWidget {
  const PixelGridBackground({super.key, required this.child});

  final Widget child;

  @override
  State<PixelGridBackground> createState() => _PixelGridBackgroundState();
}

class _PixelGridBackgroundState extends State<PixelGridBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 14),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: SentinelTheme.background,
      child: AnimatedBuilder(
        animation: _controller,
        child: widget.child,
        builder: (context, child) => CustomPaint(
          painter: _PixelGridPainter(_controller.value),
          child: child,
        ),
      ),
    );
  }
}

class _PixelGridPainter extends CustomPainter {
  const _PixelGridPainter(this.progress);

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    const cell = 28.0;
    final drift = progress * cell;
    final gridPaint = Paint()
      ..color = SentinelTheme.cyan.withValues(alpha: 0.075)
      ..strokeWidth = 1;

    for (double x = -cell + drift; x < size.width + cell; x += cell) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = -cell + drift; y < size.height + cell; y += cell) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final scanPaint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Colors.transparent,
          Color(0x3300FFCC),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, 56));
    final scanY = (size.height + 80) * progress - 40;
    canvas.drawRect(Rect.fromLTWH(0, scanY, size.width, 56), scanPaint);

    for (var index = 0; index < 18; index++) {
      final phase = progress * math.pi * 2 + index * 1.73;
      final x = (math.sin(phase * (index.isEven ? 0.7 : 1.1)) * 0.48 + 0.5) *
          size.width;
      final y = (math.cos(phase * 0.55 + index) * 0.48 + 0.5) * size.height;
      final accent =
          index % 5 == 0 ? SentinelTheme.magenta : SentinelTheme.green;
      final glow = Paint()
        ..color = accent.withValues(alpha: 0.12)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      final pixel = Paint()..color = accent.withValues(alpha: 0.62);
      canvas.drawCircle(Offset(x, y), 7, glow);
      canvas.drawRect(Rect.fromCenter(center: Offset(x, y), width: 3, height: 3),
          pixel);
    }

    final linePaint = Paint()
      ..color = SentinelTheme.magenta.withValues(alpha: 0.13)
      ..strokeWidth = 1.2;
    final start = Offset(-40 + progress * (size.width + 80), size.height * 0.23);
    canvas.drawLine(start, Offset(start.dx - 100, size.height * 0.43), linePaint);
  }

  @override
  bool shouldRepaint(covariant _PixelGridPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

/// Backward-compatible alias for older imports.
class AnimatedGrid extends PixelGridBackground {
  const AnimatedGrid({super.key, required super.child});
}
