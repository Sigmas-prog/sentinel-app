import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/apps_hub.dart';
import 'utils/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: SentinelTheme.background,
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  runApp(const SentinelApp());
}

class SentinelApp extends StatelessWidget {
  const SentinelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sentinel Marcus Hub',
      debugShowCheckedModeBanner: false,
      theme: SentinelTheme.data,
      home: const AppsHubScreen(),
    );
  }
}
