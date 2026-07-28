import 'dart:convert';
import 'package:flutter/material.dart';
import '../utils/theme.dart';
import '../widgets/cyber_card.dart';
import '../widgets/glow_button.dart';

/// Safe, local utilities: these do not access other people's devices or accounts.
class ToolsScreen extends StatefulWidget { const ToolsScreen({super.key}); @override State<ToolsScreen> createState()=>_ToolsScreenState(); }
class _ToolsScreenState extends State<ToolsScreen> {
  final _text=TextEditingController();
  String _result='Выбери инструмент ниже';
  int _tab=0;
  @override void dispose(){_text.dispose();super.dispose();}
  void _run(){final v=_text.text; if(_tab==0){
    final score=(v.length>=12?2:0)+(RegExp(r'[A-ZА-Я]').hasMatch(v)?1:0)+(RegExp(r'[0-9]').hasMatch(v)?1:0)+(RegExp(r'[^a-zA-Zа-яА-Я0-9]').hasMatch(v)?1:0);
    _result=score>=4?'СИЛЬНЫЙ ПАРОЛЬ  // $score / 5':score>=3?'СРЕДНИЙ ПАРОЛЬ  // $score / 5':'СЛАБЫЙ ПАРОЛЬ  // $score / 5';
  } else if(_tab==1){
    final bytes=utf8.encode(v); var h=2166136261; for(final b in bytes){h^=b;h=(h*16777619)&0xffffffff;} _result='LOCAL FNV-1A\n${h.toRadixString(16).padLeft(8,'0').toUpperCase()}';
  } else {
    final ok=RegExp(r'^[a-zA-Z0-9.-]+$').hasMatch(v); _result=ok?'АДРЕС ВЫГЛЯДИТ КОРРЕКТНО\nДля проверки введи: ping $v':'Используй домен без http:// и пробелов';
  }}
  @override Widget build(BuildContext context)=>ListView(padding:const EdgeInsets.all(16),children:[
    const Text('MINI TOOLS',style:TextStyle(fontSize:21,fontWeight:FontWeight.bold,color:SentinelTheme.green)),
    const SizedBox(height:6),const Text('Безопасные локальные проверки — без доступа к чужим данным.'),const SizedBox(height:16),
    SegmentedButton<int>(segments:const [ButtonSegment(value:0,label:Text('Пароль'),icon:Icon(Icons.key_outlined)),ButtonSegment(value:1,label:Text('Хеш'),icon:Icon(Icons.tag)),ButtonSegment(value:2,label:Text('Домен'),icon:Icon(Icons.language))],selected:{_tab},onSelectionChanged:(v)=>setState(()=>_tab=v.first)),
    const SizedBox(height:14),CyberCard(title:_tab==0?'PASSWORD LAB':_tab==1?'TEXT FINGERPRINT':'DOMAIN CHECK',accent:SentinelTheme.green,child:Column(crossAxisAlignment:CrossAxisAlignment.stretch,children:[TextField(controller:_text,obscureText:_tab==0,style:const TextStyle(color:SentinelTheme.cyan),decoration:InputDecoration(hintText:_tab==0?'Введи пароль для оценки':_tab==1?'Любой текст':'example.com',border:const OutlineInputBorder())),const SizedBox(height:12),GlowButton(label:'ЗАПУСТИТЬ',icon:Icons.play_arrow,color:SentinelTheme.green,onPressed:_run),const SizedBox(height:15),Text(_result,style:const TextStyle(color:SentinelTheme.cyan,fontSize:14,fontWeight:FontWeight.bold))]))
  ]);
}
