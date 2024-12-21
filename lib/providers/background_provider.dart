import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class BackgroundSettings {
  final String? imagePath;
  final double opacity;
  final BlendMode blendMode;
  final bool useDefault;

  BackgroundSettings({
    this.imagePath,
    this.opacity = 0.15,
    this.blendMode = BlendMode.srcOver,
    this.useDefault = true,
  });

  Map<String, dynamic> toJson() => {
        'imagePath': imagePath,
        'opacity': opacity,
        'blendMode': blendMode.index,
        'useDefault': useDefault,
      };

  factory BackgroundSettings.fromJson(Map<String, dynamic> json) {
    return BackgroundSettings(
      imagePath: json['imagePath'],
      opacity: json['opacity'] ?? 0.15,
      blendMode: BlendMode.values[json['blendMode'] ?? BlendMode.srcOver.index],
      useDefault: json['useDefault'] ?? true,
    );
  }
}

class BackgroundProvider with ChangeNotifier {
  final SharedPreferences _prefs;
  final Map<String, BackgroundSettings> _pageBackgrounds = {};
  static const String _prefsKey = 'page_backgrounds';

  BackgroundProvider(this._prefs) {
    _loadSettings();
  }

  BackgroundSettings getBackgroundForPage(String pageName) {
    return _pageBackgrounds[pageName] ?? BackgroundSettings();
  }

  Future<void> setBackgroundForPage(
    String pageName,
    String? imagePath, {
    double? opacity,
    BlendMode? blendMode,
  }) async {
    final currentSettings = _pageBackgrounds[pageName] ?? BackgroundSettings();
    _pageBackgrounds[pageName] = BackgroundSettings(
      imagePath: imagePath,
      opacity: opacity ?? currentSettings.opacity,
      blendMode: blendMode ?? currentSettings.blendMode,
      useDefault: imagePath == null,
    );
    await _saveSettings();
    notifyListeners();
  }

  Future<void> updateOpacity(String pageName, double opacity) async {
    final settings = _pageBackgrounds[pageName];
    if (settings != null) {
      _pageBackgrounds[pageName] = BackgroundSettings(
        imagePath: settings.imagePath,
        opacity: opacity,
        blendMode: settings.blendMode,
        useDefault: settings.useDefault,
      );
      await _saveSettings();
      notifyListeners();
    }
  }

  Future<void> updateBlendMode(String pageName, BlendMode blendMode) async {
    final settings = _pageBackgrounds[pageName];
    if (settings != null) {
      _pageBackgrounds[pageName] = BackgroundSettings(
        imagePath: settings.imagePath,
        opacity: settings.opacity,
        blendMode: blendMode,
        useDefault: settings.useDefault,
      );
      await _saveSettings();
      notifyListeners();
    }
  }

  Future<void> _loadSettings() async {
    final String? jsonStr = _prefs.getString(_prefsKey);
    if (jsonStr != null) {
      final Map<String, dynamic> data = json.decode(jsonStr);
      data.forEach((key, value) {
        _pageBackgrounds[key] = BackgroundSettings.fromJson(value);
      });
    }
  }

  Future<void> _saveSettings() async {
    final Map<String, dynamic> data = {};
    _pageBackgrounds.forEach((key, value) {
      data[key] = value.toJson();
    });
    await _prefs.setString(_prefsKey, json.encode(data));
  }

  Future<void> resetToDefault(String pageName) async {
    _pageBackgrounds[pageName] = BackgroundSettings();
    await _saveSettings();
    notifyListeners();
  }
}
