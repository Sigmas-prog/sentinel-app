import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../utils/theme.dart';
import '../widgets/neon_scaffold.dart';

class ArchiveScreen extends StatefulWidget {
  const ArchiveScreen({super.key});

  @override
  State<ArchiveScreen> createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends State<ArchiveScreen>
    with SingleTickerProviderStateMixin {
  static const _media = [
    _ArchiveItem(
      title: 'MARCUS // BAY AREA',
      caption: 'Official Watch Dogs 2 reveal artwork',
      url:
          'https://staticctf.ubisoft.com/J3yJr34U2pZ2Ieem48Dwy9uqj5PNUQTn/'
          '4wyWWb2tHvx6ETF19VPEKM/00e2e23901abfb3d5353de496b1b8cba/'
          'wd2_marcus_thumb_310302.jpg',
    ),
    _ArchiveItem(
      title: 'DEDSEC // OPERATION',
      caption: 'Official Ubisoft reveal screenshot',
      url:
          'https://ubistatic-a.ubisoft.com/0090/PROD/ubiblog/2016/6/'
          'wd2_sc4_alt_ann_reveal.jpg',
    ),
    _ArchiveItem(
      title: 'REMOTE // CRANE',
      caption: 'Official Ubisoft gameplay screenshot',
      url:
          'https://ubistatic-a.ubisoft.com/0090/PROD/ubiblog/2016/6/'
          'wd2_crane.jpg',
    ),
    _ArchiveItem(
      title: 'CITY // TWIN PEAKS',
      caption: 'Official Ubisoft world screenshot',
      url:
          'https://ubistatic-a.ubisoft.com/0090/PROD/ubiblog/2016/6/'
          'wd2_twinpeaks.jpg',
    ),
  ];

  final _pageController = PageController(viewportFraction: 0.9);
  late final AnimationController _scan = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2600),
  )..repeat();
  int _page = 0;

  @override
  void dispose() {
    _pageController.dispose();
    _scan.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NeonScaffold(
      title: 'ARCHIVE // DEDSEC',
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 14, 16, 4),
            child: Row(
              children: [
                Icon(Icons.circle, size: 8, color: SentinelTheme.green),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'OFFICIAL UBISOFT MEDIA // NETWORK CACHE',
                    style: TextStyle(
                      color: SentinelTheme.green,
                      fontSize: 9,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _media.length,
              onPageChanged: (value) => setState(() => _page = value),
              itemBuilder: (context, index) => AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  var scale = 1.0;
                  if (_pageController.hasClients &&
                      _pageController.position.hasContentDimensions) {
                    final value = (_pageController.page ?? 0) - index;
                    scale =
                        (1 - value.abs() * 0.08).clamp(0.9, 1.0).toDouble();
                  }
                  return Transform.scale(scale: scale, child: child);
                },
                child: _ArchiveCard(item: _media[index], scan: _scan),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _media.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: index == _page ? 22 : 7,
                  height: 7,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  color: index == _page
                      ? SentinelTheme.cyan
                      : SentinelTheme.muted.withValues(alpha: 0.35),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ArchiveCard extends StatelessWidget {
  const _ArchiveCard({required this.item, required this.scan});

  final _ArchiveItem item;
  final Animation<double> scan;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 14, 6, 6),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(color: SentinelTheme.cyan),
          boxShadow: [
            BoxShadow(
              color: SentinelTheme.cyan.withValues(alpha: 0.22),
              blurRadius: 18,
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: item.url,
              fit: BoxFit.cover,
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(color: SentinelTheme.cyan),
              ),
              errorWidget: (context, url, error) => const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.cloud_off,
                      color: SentinelTheme.magenta,
                      size: 46,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'MEDIA LINK OFFLINE',
                      style: TextStyle(color: SentinelTheme.magenta),
                    ),
                  ],
                ),
              ),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Color(0xE6000000)],
                  stops: [0.52, 1],
                ),
              ),
            ),
            AnimatedBuilder(
              animation: scan,
              builder: (context, child) => Positioned(
                left: 0,
                right: 0,
                top: scan.value * MediaQuery.sizeOf(context).height * 0.62,
                child: Container(
                  height: 3,
                  color: SentinelTheme.green.withValues(alpha: 0.72),
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 18,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      color: SentinelTheme.cyan,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.caption,
                    style: const TextStyle(
                      color: SentinelTheme.text,
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    '© Ubisoft // fan-made interface',
                    style: TextStyle(color: SentinelTheme.muted, fontSize: 8),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArchiveItem {
  const _ArchiveItem({
    required this.title,
    required this.caption,
    required this.url,
  });

  final String title;
  final String caption;
  final String url;
}
