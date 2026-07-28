import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/theme.dart';
import '../widgets/cyber_card.dart';
import '../widgets/glow_button.dart';

/// Local camera: photos stay in the app session and are never uploaded.
class LensScreen extends StatefulWidget {
  const LensScreen({super.key});
  @override State<LensScreen> createState() => _LensScreenState();
}

class _LensScreenState extends State<LensScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  bool _busy = false;

  Future<void> _takePhoto() async {
    setState(() => _busy = true);
    try {
      final image = await _picker.pickImage(source: ImageSource.camera, imageQuality: 88);
      if (mounted && image != null) setState(() => _image = image);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('LENS // LOCAL CAMERA', style: TextStyle(fontSize: 21, color: SentinelTheme.cyan, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          const Text('Кадры остаются только на телефоне.'),
          const SizedBox(height: 16),
          CyberCard(
            title: 'PREVIEW',
            accent: SentinelTheme.cyan,
            child: AspectRatio(
              aspectRatio: 3 / 4,
              child: _image == null
                  ? const Center(child: Icon(Icons.camera_alt_outlined, size: 92, color: SentinelTheme.muted))
                  : ClipRRect(borderRadius: BorderRadius.circular(5), child: Image.file(File(_image!.path), fit: BoxFit.cover)),
            ),
          ),
          const SizedBox(height: 14),
          GlowButton(label: _busy ? 'ОТКРЫВАЮ КАМЕРУ...' : 'СДЕЛАТЬ КАДР', icon: Icons.camera, onPressed: _busy ? null : _takePhoto),
        ],
      );
}
