import 'dart:async';
import 'package:flutter/material.dart';
import '../utils/theme.dart';
import '../widgets/cyber_card.dart';
import '../widgets/glow_button.dart';
class EffectScreen extends StatefulWidget { const EffectScreen({super.key}); @override State<EffectScreen> createState() => _EffectScreenState(); }
class _EffectScreenState extends State<EffectScreen> { double _progress=0; Timer? _timer; String _status='ГОТОВ К ВИЗУАЛИЗАЦИИ';
 void _start(){_timer?.cancel(); setState((){_progress=0;_status='СБОР ДАННЫХ...';}); _timer=Timer.periodic(const Duration(milliseconds: 90),(t){setState((){_progress=(_progress+.02).clamp(0,1); if(_progress>.7)_status='ОБРАБОТКА СИГНАЛА...'; if(_progress>=1){_status='ВИЗУАЛИЗАЦИЯ ЗАВЕРШЕНА';t.cancel();}});});}
 @override void dispose(){_timer?.cancel();super.dispose();}
 @override Widget build(BuildContext context)=>Center(child: Padding(padding: const EdgeInsets.all(18), child: CyberCard(title:'DATA VISUALIZER', accent: SentinelTheme.violet, child: Column(mainAxisSize: MainAxisSize.min, children:[const Icon(Icons.hub, color: SentinelTheme.violet, size:90), const SizedBox(height:20), Text(_status, style: const TextStyle(color: SentinelTheme.violet)), const SizedBox(height:12), LinearProgressIndicator(value:_progress, minHeight:9, color:SentinelTheme.green, backgroundColor:SentinelTheme.background), const SizedBox(height:10), Text('${(_progress*100).round()}%',style:const TextStyle(fontSize:24,color:SentinelTheme.cyan)), const SizedBox(height:20), GlowButton(label:'ЗАПУСТИТЬ ЭФФЕКТ', color:SentinelTheme.violet, icon:Icons.play_arrow, onPressed:_start)]))); }
