import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/theme.dart';
import '../widgets/cyber_card.dart';
import '../widgets/glow_button.dart';
import '../widgets/neon_scaffold.dart';

class LensScreen extends StatefulWidget {
  const LensScreen({super.key});

  @override
  State<LensScreen> createState() => _LensScreenState();
}

class _LensScreenState extends State<LensScreen> {
  final _picker = ImagePicker();
  XFile? _image;
  bool _busy = false;
  bool _flash = false;
  String _status = 'CAMERA STANDBY';

  Future<void> _takePhoto() async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _flash = true;
      _status = 'OPENING SYSTEM CAMERA...';
    });
    await Future<void>.delayed(const Duration(milliseconds: 100));
    if (mounted) setState(() => _flash = false);

    try {
      final image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 92,
        maxWidth: 2400,
      );
      if (!mounted) return;
      setState(() {
        if (image != null) _image = image;
        _status = image == null ? 'CAPTURE CANCELLED' : 'FRAME CAPTURED // LOCAL';
      });
    } catch (error) {
      if (mounted) setState(() => _status = 'CAMERA ERROR // $error');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return NeonScaffold(
      title: 'LENS // CAMERA',
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CyberCard(
            title: 'OPTICAL FEED',
            accent: SentinelTheme.magenta,
            pulse: _busy,
            padding: const EdgeInsets.all(8),
            child: AspectRatio(
              aspectRatio: 3 / 4,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ColoredBox(
                    color: Colors.black,
                    child: _image == null
                        ? const _EmptyLens()
                        : Image.file(
                            File(_image!.path),
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.medium,
                          ),
                  ),
                  const IgnorePointer(child: CustomPaint(painter: _LensPainter())),
                  AnimatedOpacity(
                    opacity: _flash ? 1 : 0,
                    duration: const Duration(milliseconds: 130),
                    child: const ColoredBox(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                color: _busy ? SentinelTheme.warning : SentinelTheme.green,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _status,
                  style: const TextStyle(
                    color: SentinelTheme.green,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          GlowButton(
            label: _busy ? 'CAMERA ACTIVE...' : 'СНЯТЬ',
            icon: Icons.camera,
            color: SentinelTheme.magenta,
            onPressed: _busy ? null : _takePhoto,
          ),
          const SizedBox(height: 12),
          const Text(
            'Снимок хранится во временном файле приложения и никуда не отправляется.',
            style: TextStyle(color: SentinelTheme.muted, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class _EmptyLens extends StatelessWidget {
  const _EmptyLens();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.center_focus_strong,
          color: SentinelTheme.magenta,
          size: 82,
        ),
        SizedBox(height: 14),
        Text(
          'NO FRAME',
          style: TextStyle(
            color: SentinelTheme.muted,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }
}

class _LensPainter extends CustomPainter {
  const _LensPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = SentinelTheme.cyan.withValues(alpha: 0.7)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    const length = 28.0;
    canvas.drawLine(const Offset(8, 8), const Offset(8 + length, 8), paint);
    canvas.drawLine(const Offset(8, 8), const Offset(8, 8 + length), paint);
    canvas.drawLine(Offset(size.width - 8, 8),
        Offset(size.width - 8 - length, 8), paint);
    canvas.drawLine(Offset(size.width - 8, 8),
        Offset(size.width - 8, 8 + length), paint);
    canvas.drawLine(Offset(8, size.height - 8),
        Offset(8 + length, size.height - 8), paint);
    canvas.drawLine(Offset(8, size.height - 8),
        Offset(8, size.height - 8 - length), paint);
    canvas.drawLine(Offset(size.width - 8, size.height - 8),
        Offset(size.width - 8 - length, size.height - 8), paint);
    canvas.drawLine(Offset(size.width - 8, size.height - 8),
        Offset(size.width - 8, size.height - 8 - length), paint);

    final cross = Paint()
      ..color = SentinelTheme.magenta.withValues(alpha: 0.45)
      ..strokeWidth = 1;
    canvas.drawLine(Offset(size.width / 2 - 16, size.height / 2),
        Offset(size.width / 2 + 16, size.height / 2), cross);
    canvas.drawLine(Offset(size.width / 2, size.height / 2 - 16),
        Offset(size.width / 2, size.height / 2 + 16), cross);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
