import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../utils/theme.dart';
import '../widgets/cyber_card.dart';
import '../widgets/glow_button.dart';

class CityMapScreen extends StatefulWidget {
  const CityMapScreen({super.key});

  @override
  State<CityMapScreen> createState() => _CityMapScreenState();
}

class _CityMapScreenState extends State<CityMapScreen> {
  final MapController _map = MapController();
  LatLng _position = const LatLng(41.8781, -87.6298);
  String _status = 'Нажми LOCATE, чтобы показать своё положение.';
  bool _loading = false;

  Future<void> _locate() async {
    setState(() => _loading = true);
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        throw Exception('Включи геолокацию в настройках телефона.');
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw Exception('Разрешение на геолокацию не выдано.');
      }
      final point = await Geolocator.getCurrentPosition();
      final next = LatLng(point.latitude, point.longitude);
      if (!mounted) return;
      setState(() {
        _position = next;
        _status = 'Точка найдена: ${point.latitude.toStringAsFixed(5)}, ${point.longitude.toStringAsFixed(5)}';
      });
      _map.move(next, 16);
    } catch (error) {
      if (mounted) setState(() => _status = 'LOCATION // $error');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('CITY // VIEW', style: TextStyle(fontSize: 21, color: SentinelTheme.cyan, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          const Text('Твоя карта и ориентиры города'),
          const SizedBox(height: 14),
          SizedBox(
            height: 340,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Stack(children: [
                FlutterMap(
                  mapController: _map,
                  options: MapOptions(initialCenter: _position, initialZoom: 12),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.sentinel_app',
                    ),
                    MarkerLayer(markers: [Marker(point: _position, width: 55, height: 55, child: const Icon(Icons.adjust, size: 42, color: SentinelTheme.green))]),
                  ],
                ),
                Positioned(top: 10, left: 10, child: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5), color: SentinelTheme.background.withOpacity(.86), child: const Text('LIVE MAP', style: TextStyle(fontSize: 11, color: SentinelTheme.green, letterSpacing: 1.3)))),
              ]),
            ),
          ),
          const SizedBox(height: 12),
          CyberCard(title: 'POSITION STATUS', accent: SentinelTheme.green, child: Text(_status, style: const TextStyle(fontSize: 12))),
          const SizedBox(height: 14),
          GlowButton(label: _loading ? 'ПОИСК...' : 'LOCATE ME', icon: Icons.my_location, color: SentinelTheme.green, onPressed: _loading ? null : _locate),
        ],
      );
}
