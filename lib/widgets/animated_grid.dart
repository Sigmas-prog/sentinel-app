import 'dart:math';
import 'package:flutter/material.dart';
import '../utils/theme.dart';

class AnimatedGrid extends StatefulWidget {
  const AnimatedGrid({super.key, required this.child});
  final Widget child;
  @override
  State<AnimatedGrid> createState() => _AnimatedGridState();
}

class _AnimatedGridState extends State<AnimatedGrid>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: const Duration(seconds: 12))
        ..repeat();
  @override
  void dispose() { _controller.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _controller,
        builder: (_, __) => CustomPaint(
          painter: _GridPainter(_controller.value),
          child: widget.child,
        ),
      );
}

class _GridPainter extends CustomPainter {
  _GridPainter(this.t); final double t;
  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()..color = SentinelTheme.cyan.withOpacity(.09)..strokeWidth = 1;
    const spacing = 32.0;
    for (double x = -spacing; x < size.width + spacing; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    for (double y = -spacing + (t * spacing); y < size.height + spacing; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }
    final dot = Paint()..color = SentinelTheme.green.withOpacity(.55);
    for (var i = 0; i < 11; i++) {
      final x = (sin(t * pi * 2 + i * 2.31) * .45 + .5) * size.width;
      final y = (cos(t * pi * 2 + i * 1.27) * .45 + .5) * size.height;
      canvas.drawCircle(Offset(x, y), i.isEven ? 2.2 : 1.2, dot);
    }
  }
  @override bool shouldRepaint(covariant _GridPainter old) => old.t != t;
}
