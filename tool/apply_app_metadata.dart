import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  final pubspec = File('pubspec.yaml');
  if (!pubspec.existsSync()) {
    stderr.writeln('pubspec.yaml not found');
    exit(1);
  }
  final text = await pubspec.readAsString();
  final yaml = _parseYaml(text);
  final meta = (yaml['app_metadata'] as Map?) ?? {};
  final appName = meta['application_name'] as String?;
  final bundleId = meta['android_application_id'] as String?;

  if (bundleId != null && bundleId.isNotEmpty) {
    await _run([
      'dart',
      'run',
      'rename',
      'setBundleId',
      '--value',
      bundleId,
      '--targets',
      'android,ios',
    ]);
  }
  if (appName != null && appName.isNotEmpty) {
    await _run([
      'dart',
      'run',
      'rename',
      'setAppName',
      '--value',
      appName,
      '--targets',
      'android,ios,windows,macos,linux,web',
    ]);
  }
}

Map _parseYaml(String text) {
  // Minimal YAML to JSON via package:yaml is preferred, but avoid adding deps.
  // Assume well-formed and simple structure; not a general parser.
  // For safety, fallback to shelling out `dart run tool` only using provided constants.
  final lines = LineSplitter.split(text).toList();
  final map = <String, dynamic>{};
  String? currentSection;
  for (final line in lines) {
    if (line.trim().isEmpty || line.trimLeft().startsWith('#')) continue;
    if (!line.startsWith(' ') && line.contains(':')) {
      currentSection = line.split(':').first.trim();
      map[currentSection] = {};
    } else if (currentSection == 'app_metadata') {
      final idx = line.indexOf(':');
      if (idx > 0) {
        final k = line.substring(0, idx).trim();
        final v = line
            .substring(idx + 1)
            .trim()
            .replaceAll('"', '')
            .replaceAll("'", '');
        if (k.isNotEmpty) (map[currentSection] as Map)[k] = v;
      }
    }
  }
  return map;
}

Future<void> _run(List<String> cmd) async {
  final res = await Process.run(
    cmd.first,
    cmd.skip(1).toList(),
    runInShell: true,
  );
  stdout.write(res.stdout);
  stderr.write(res.stderr);
  if (res.exitCode != 0) exit(res.exitCode);
}
