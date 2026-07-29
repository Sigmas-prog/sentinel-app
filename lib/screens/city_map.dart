import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../utils/theme.dart';
import '../widgets/glow_button.dart';
import '../widgets/neon_scaffold.dart';

class CityMapScreen extends StatefulWidget {
  const CityMapScreen({super.key});

  @override
  State<CityMapScreen> createState() => _CityMapScreenState();
}

class _CityMapScreenState extends State<CityMapScreen> {
  static const _cities = <_CityPoint>[
    _CityPoint('MOSCOW', LatLng(55.7558, 37.6173), SentinelTheme.cyan),
    _CityPoint('SPB', LatLng(59.9343, 30.3351), SentinelTheme.magenta),
    _CityPoint('PARIS', LatLng(48.8566, 2.3522), SentinelTheme.green),
  ];

  final _map = MapController();
  LatLng? _myLocation;
  String _status = 'THREE NODES ONLINE';
  bool _loading = false;

  Future<void> _locate() async {
    if (_loading) return;
    setState(() {
      _loading = true;
      _status = 'REQUESTING GPS FIX...';
    });
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        throw Exception('Включи геолокацию на телефоне.');
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied) {
        throw Exception('Разрешение на геолокацию не выдано.');
      }
      if (permission == LocationPermission.deniedForever) {
        throw Exception('Разрешение запрещено навсегда. Открой настройки.');
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );
      final point = LatLng(position.latitude, position.longitude);
      if (!mounted) return;
      setState(() {
        _myLocation = point;
        _status =
            'MY NODE // ${position.latitude.toStringAsFixed(5)}, ${position.longitude.toStringAsFixed(5)}';
      });
      _map.move(point, 15);
    } catch (error) {
      if (mounted) setState(() => _status = 'GPS ERROR // $error');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final markers = [
      ..._cities.map(
        (city) => Marker(
          point: city.point,
          width: 84,
          height: 58,
          child: _MapMarker(label: city.name, color: city.color),
        ),
      ),
      if (_myLocation != null)
        Marker(
          point: _myLocation!,
          width: 90,
          height: 62,
          child: const _MapMarker(
            label: 'YOU',
            color: SentinelTheme.warning,
          ),
        ),
    ];

    return NeonScaffold(
      title: 'MAP // OSM',
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                FlutterMap(
                  mapController: _map,
                  options: const MapOptions(
                    initialCenter: LatLng(54.4, 22.0),
                    initialZoom: 3.2,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.sentinel.marcushub',
                    ),
                    MarkerLayer(markers: markers),
                  ],
                ),
                const Positioned.fill(
                  child: IgnorePointer(
                    child: CustomPaint(painter: _CoordinateGridPainter()),
                  ),
                ),
                const Positioned(
                  top: 12,
                  right: 12,
                  child: _Compass(),
                ),
                Positioned(
                  left: 8,
                  bottom: 6,
                  child: Container(
                    color: const Color(0xCC020609),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    child: const Text(
                      '© OpenStreetMap contributors',
                      style: TextStyle(
                        color: SentinelTheme.text,
                        fontSize: 8,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: SentinelTheme.panel,
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      color:
                          _loading ? SentinelTheme.warning : SentinelTheme.green,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _status,
                        style: const TextStyle(
                          color: SentinelTheme.green,
                          fontSize: 9,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 11),
                GlowButton(
                  label: _loading ? 'LOCATING...' : 'МОЁ МЕСТОПОЛОЖЕНИЕ',
                  icon: Icons.my_location,
                  color: SentinelTheme.cyan,
                  onPressed: _loading ? null : _locate,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CityPoint {
  const _CityPoint(this.name, this.point, this.color);

  final String name;
  final LatLng point;
  final Color color;
}

class _MapMarker extends StatelessWidget {
  const _MapMarker({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: SentinelTheme.background,
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
          child: Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Icon(Icons.location_on, color: color, size: 34),
      ],
    );
  }
}

class _Compass extends StatelessWidget {
  const _Compass();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: const Color(0xDD020609),
        shape: BoxShape.circle,
        border: Border.all(color: SentinelTheme.magenta),
      ),
      child: const Stack(
        alignment: Alignment.center,
        children: [
          Icon(Icons.navigation, color: SentinelTheme.magenta, size: 28),
          Positioned(
            top: 2,
            child: Text(
              'N',
              style: TextStyle(color: SentinelTheme.cyan, fontSize: 8),
            ),
          ),
        ],
      ),
    );
  }
}

class _CoordinateGridPainter extends CustomPainter {
  const _CoordinateGridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = SentinelTheme.cyan.withValues(alpha: 0.2)
      ..strokeWidth = 0.7;
    const step = 52.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
