import 'dart:io';
import 'system_info.dart';
import 'wifi_scanner.dart';
class TerminalService {
  TerminalService(this._system, this._wifi); final SystemInfoService _system; final WifiScannerService _wifi;
  Future<String> execute(String source) async {
    final parts = source.trim().split(RegExp(r'\\s+')); if (parts.isEmpty || parts.first.isEmpty) return '';
    switch (parts.first.toLowerCase()) {
      case 'help': return 'help — команды\\nscan — список Wi-Fi\\nshowip — сетевые данные\\ntest — проверка соединения\\nping <адрес> — DNS-проверка';
      case 'scan': final items = await _wifi.scan(); return items.isEmpty ? 'Сети не найдены.' : items.take(12).map((n) => '${n.ssid} | ${n.level} | ch ${n.channel}').join('\\n');
      case 'showip': final s = await _system.read(); return 'IP: ${s.ip}\\nWi-Fi: ${s.wifiName}\\nУстройство: ${s.device}';
      case 'test': try { final r = await InternetAddress.lookup('one.one.one.one'); return r.isNotEmpty ? 'Канал доступен: ${r.first.address}' : 'Нет ответа'; } catch (_) { return 'Соединение недоступно'; }
      case 'ping': if (parts.length < 2) return 'Использование: ping <адрес>'; try { final r = await InternetAddress.lookup(parts[1]); return 'DNS: ${parts[1]} → ${r.first.address}'; } catch (_) { return 'Адрес не найден'; }
      default: return 'Неизвестная команда: ${parts.first}. Введите help.';
    }
  }
}
