import 'package:flutter/material.dart';
import 'screens/apps_hub.dart';
import 'screens/city_map.dart';
import 'screens/dashboard.dart';
import 'screens/scanner.dart';
import 'screens/terminal.dart';
import 'utils/theme.dart';
import 'widgets/animated_grid.dart' as sentinel_grid;
void main() => runApp(const SentinelApp());
class SentinelApp extends StatelessWidget { const SentinelApp({super.key}); @override Widget build(BuildContext context) => MaterialApp(debugShowCheckedModeBanner:false, theme:SentinelTheme.data, home:const _Home()); }
class _Home extends StatefulWidget { const _Home(); @override State<_Home> createState()=>_HomeState(); }
class _HomeState extends State<_Home>{
 int _index=0;
 final _screens=const [DashboardScreen(),CityMapScreen(),ScannerScreen(),TerminalScreen(),AppsHubScreen()];
 @override Widget build(BuildContext context)=>sentinel_grid.AnimatedGrid(child:Scaffold(
  appBar:AppBar(title:const Text('SENTINEL // DEDSEC',style:TextStyle(letterSpacing:2.3,color:SentinelTheme.cyan,fontSize:16)),backgroundColor:SentinelTheme.background,elevation:0),
  body:_screens[_index],
  bottomNavigationBar:NavigationBar(backgroundColor:const Color(0xF0091720),indicatorColor:SentinelTheme.cyan.withOpacity(.15),selectedIndex:_index,onDestinationSelected:(i)=>setState(()=>_index=i),destinations:const [NavigationDestination(icon:Icon(Icons.dashboard_outlined),selectedIcon:Icon(Icons.dashboard),label:'Статус'),NavigationDestination(icon:Icon(Icons.map_outlined),selectedIcon:Icon(Icons.map),label:'Город'),NavigationDestination(icon:Icon(Icons.wifi_find),label:'Wi-Fi'),NavigationDestination(icon:Icon(Icons.terminal),label:'Консоль'),NavigationDestination(icon:Icon(Icons.apps_outlined),selectedIcon:Icon(Icons.apps),label:'Приложения')]
 )));
}
