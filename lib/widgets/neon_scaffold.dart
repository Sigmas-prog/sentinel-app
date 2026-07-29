import 'package:flutter/material.dart';

import '../utils/theme.dart';
import 'animated_grid.dart';

class NeonScaffold extends StatelessWidget {
  const NeonScaffold({
    super.key,
    required this.title,
    required this.child,
    this.actions = const [],
    this.showBack = true,
  });

  final String title;
  final Widget child;
  final List<Widget> actions;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    return PixelGridBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: showBack,
          title: Text(title),
          actions: actions,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                color: SentinelTheme.cyan,
                boxShadow: [
                  BoxShadow(
                    color: SentinelTheme.cyan.withValues(alpha: 0.6),
                    blurRadius: 9,
                  ),
                ],
              ),
            ),
          ),
        ),
        body: SafeArea(top: false, child: child),
      ),
    );
  }
}
