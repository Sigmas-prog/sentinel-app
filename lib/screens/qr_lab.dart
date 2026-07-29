import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../utils/theme.dart';
import '../widgets/cyber_card.dart';
import '../widgets/glow_button.dart';
import '../widgets/neon_scaffold.dart';

class QrLabScreen extends StatefulWidget {
  const QrLabScreen({super.key});

  @override
  State<QrLabScreen> createState() => _QrLabScreenState();
}

class _QrLabScreenState extends State<QrLabScreen> {
  final _text = TextEditingController(text: 'SENTINEL // DEDSEC NODE');
  final _scanner = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
  );
  String _qrData = 'SENTINEL // DEDSEC NODE';
  String _scanned = 'NO CODE';
  bool _scanMode = false;

  @override
  void dispose() {
    _text.dispose();
    _scanner.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    String? value;
    for (final barcode in capture.barcodes) {
      if (barcode.rawValue != null) {
        value = barcode.rawValue;
        break;
      }
    }
    if (value == null || value == _scanned) return;
    setState(() => _scanned = value);
    HapticFeedback.mediumImpact();
  }

  @override
  Widget build(BuildContext context) {
    return NeonScaffold(
      title: 'QR LAB // LIVE',
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(
                child: GlowButton(
                  label: 'BUILD',
                  icon: Icons.qr_code_2,
                  color: SentinelTheme.cyan,
                  onPressed: () => setState(() => _scanMode = false),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GlowButton(
                  label: 'SCAN',
                  icon: Icons.qr_code_scanner,
                  color: SentinelTheme.magenta,
                  onPressed: () => setState(() => _scanMode = true),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (!_scanMode)
            CyberCard(
              title: 'QR GENERATOR',
              accent: SentinelTheme.cyan,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _text,
                    minLines: 2,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'Текст, ссылка или контакт',
                    ),
                  ),
                  const SizedBox(height: 12),
                  GlowButton(
                    label: 'GENERATE CODE',
                    icon: Icons.bolt,
                    color: SentinelTheme.green,
                    onPressed: () => setState(() {
                      _qrData = _text.text.isEmpty ? ' ' : _text.text;
                    }),
                  ),
                  const SizedBox(height: 18),
                  Center(
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(12),
                      child: QrImageView(
                        data: _qrData,
                        version: QrVersions.auto,
                        size: 220,
                        backgroundColor: Colors.white,
                        eyeStyle: const QrEyeStyle(
                          eyeShape: QrEyeShape.square,
                          color: Colors.black,
                        ),
                        dataModuleStyle: const QrDataModuleStyle(
                          dataModuleShape: QrDataModuleShape.square,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          else ...[
            CyberCard(
              title: 'CAMERA SCANNER',
              accent: SentinelTheme.magenta,
              pulse: true,
              child: SizedBox(
                height: 330,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    MobileScanner(
                      controller: _scanner,
                      onDetect: _onDetect,
                    ),
                    Center(
                      child: Container(
                        width: 220,
                        height: 220,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: SentinelTheme.green,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            CyberCard(
              title: 'DECODED DATA',
              accent: SentinelTheme.green,
              child: Row(
                children: [
                  Expanded(child: SelectableText(_scanned)),
                  IconButton(
                    onPressed: () =>
                        Clipboard.setData(ClipboardData(text: _scanned)),
                    icon: const Icon(
                      Icons.copy,
                      color: SentinelTheme.green,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
