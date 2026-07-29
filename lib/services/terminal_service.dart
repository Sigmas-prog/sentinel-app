import 'dart:async';
import 'dart:io';

class TerminalService {
  static const _safeCatFiles = {
    'version': '/proc/version',
    'meminfo': '/proc/meminfo',
    'uptime': '/proc/uptime',
    'cpuinfo': '/proc/cpuinfo',
  };

  static const _safeListPaths = {
    '/': '/',
    '/system': '/system',
    '/system/bin': '/system/bin',
    '/proc': '/proc',
  };

  Future<String> execute(String source) async {
    final parts = source.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '';

    final command = parts.first.toLowerCase();
    switch (command) {
      case 'help':
        return 'AVAILABLE COMMANDS\n'
            'ping <host>   network reachability\n'
            'ls [path]     list /, /system, /system/bin or /proc\n'
            'cat <file>    version, meminfo, cpuinfo or uptime\n'
            'echo <text>   print local text\n'
            'ifconfig      Android network interfaces\n'
            'clear         clear terminal';
      case 'ping':
        if (parts.length != 2 || !_validHost(parts[1])) {
          return 'USAGE: ping example.com';
        }
        return _process('ping', ['-c', '4', parts[1]]);
      case 'ls':
        final requested = parts.length > 1 ? parts[1] : '/system/bin';
        final path = _safeListPaths[requested];
        if (path == null) {
          return 'PATH BLOCKED. AVAILABLE: ${_safeListPaths.keys.join(', ')}';
        }
        return _process('ls', ['-la', path]);
      case 'cat':
        if (parts.length != 2 || !_safeCatFiles.containsKey(parts[1])) {
          return 'USAGE: cat version|meminfo|cpuinfo|uptime';
        }
        return _process('cat', [_safeCatFiles[parts[1]]!]);
      case 'echo':
        return parts.skip(1).join(' ');
      case 'ifconfig':
        return _process('ifconfig', const []);
      case 'clear':
        return '__CLEAR__';
      default:
        return 'COMMAND NOT FOUND: $command\nTYPE help';
    }
  }

  bool _validHost(String host) =>
      RegExp(r'^[a-zA-Z0-9.-]{1,253}$').hasMatch(host);

  Future<String> _process(String executable, List<String> arguments) async {
    try {
      final result = await Process.run(
        executable,
        arguments,
        runInShell: false,
      ).timeout(const Duration(seconds: 16));
      final output = result.stdout.toString().trim();
      final error = result.stderr.toString().trim();
      final combined = [output, error].where((line) => line.isNotEmpty).join('\n');
      if (combined.isEmpty) return 'EXIT ${result.exitCode} // NO OUTPUT';
      return combined.length > 12000 ? combined.substring(0, 12000) : combined;
    } on ProcessException catch (error) {
      return '$executable IS NOT AVAILABLE ON THIS ANDROID BUILD\n$error';
    } on TimeoutException {
      return '$executable TIMEOUT';
    } catch (error) {
      return '$executable ERROR: $error';
    }
  }
}
