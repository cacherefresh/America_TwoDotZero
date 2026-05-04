import 'package:flutter/services.dart' show rootBundle;
import 'package:yaml/yaml.dart';

/// Centralized configuration for all America 2.0 web references
class AppConfig {
  static late Map<String, dynamic> _config;
  static bool _initialized = false;

  /// Initialize the configuration from YAML file
  static Future<void> initialize() async {
    if (_initialized) return;
    
    final yamlString = await rootBundle.loadString('assets/config.yaml');
    final yamlMap = loadYaml(yamlString) as Map;
    _config = Map<String, dynamic>.from(yamlMap);
    _initialized = true;
  }

  /// ==================== DOMAINS ====================
  static String get mainDomain => _getPath('domains.main');
  static String get githubPagesDomain => _getPath('domains.github_pages');
  static String get githubRepoDomain => _getPath('domains.github_repo');

  /// ==================== SUBDOMAINS ====================
  static String get gameSubdomain => _getPath('subdomains.game.full_domain');
  static String get abeSubdomain => _getPath('subdomains.abe.full_domain');

  /// ==================== APPS ====================
  static String get gameUrl => _getPath('apps.game.url');
  static String get gameName => _getPath('apps.game.name');
  static String get gameDescription => _getPath('apps.game.description');

  static String get abeUrl => _getPath('apps.abe.url');
  static String get abeFallbackUrl => _getPath('apps.abe.fallback_url');
  static String get abeName => _getPath('apps.abe.name');
  static String get abeDescription => _getPath('apps.abe.description');

  static String get poeUrl => _getPath('apps.peace_on_earth.url');
  static String get poeName => _getPath('apps.peace_on_earth.name');
  static String get poeDescription => _getPath('apps.peace_on_earth.description');

  /// ==================== WEB 2.0 ====================
  static String get web2Name => _getPath('web_2.name');
  static String get web2Description => _getPath('web_2.description');
  static String get web2AssetsPath => _getPath('web_2.assets_path');

  /// ==================== HOME ====================
  static String get appName => _getPath('home.name');
  static String get appDescription => _getPath('home.description');
  static String get appShortDescription => _getPath('home.short_description');

  /// Helper method to safely access nested YAML values
  static String _getPath(String path) {
    if (!_initialized) {
      throw StateError('AppConfig not initialized. Call AppConfig.initialize() first.');
    }
    
    final parts = path.split('.');
    dynamic value = _config;
    
    for (final part in parts) {
      if (value is Map) {
        value = value[part];
      } else {
        throw KeyError('Config path not found: $path');
      }
    }
    
    return value?.toString() ?? '';
  }
}

class KeyError extends Error {
  final String message;
  KeyError(this.message);

  @override
  String toString() => message;
}
