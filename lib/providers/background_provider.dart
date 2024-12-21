import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// 定义简化的混合模式选项
class BlendModeOption {
  final BlendMode mode;
  final String name;
  final String description;

  const BlendModeOption({
    required this.mode,
    required this.name,
    required this.description,
  });
}

class BackgroundSettings {
  final String? imagePath;
  final double opacity;
  final BlendMode blendMode;
  final bool useDefault;

  static const List<BlendModeOption> blendModeOptions = [
    BlendModeOption(
      mode: BlendMode.srcOver,
      name: '正常',
      description: '默认模式，直接显示图片',
    ),
    BlendModeOption(
      mode: BlendMode.multiply,
      name: '正片叠底',
      description: '加深图片颜色，增加氛围感',
    ),
    BlendModeOption(
      mode: BlendMode.screen,
      name: '滤色',
      description: '提亮图片，创造梦幻效果',
    ),
    BlendModeOption(
      mode: BlendMode.overlay,
      name: '叠加',
      description: '增强对比度，使图片更有层次感',
    ),
    BlendModeOption(
      mode: BlendMode.softLight,
      name: '柔光',
      description: '柔和的光效，适合营造温馨氛围',
    ),
  ];

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
    // 确保混合模式在允许的范围内
    final blendModeIndex = json['blendMode'] ?? BlendMode.srcOver.index;
    final availableModes = blendModeOptions.map((e) => e.mode).toList();
    final blendMode = availableModes.contains(BlendMode.values[blendModeIndex])
        ? BlendMode.values[blendModeIndex]
        : BlendMode.srcOver;

    return BackgroundSettings(
      imagePath: json['imagePath'],
      opacity: json['opacity'] ?? 0.15,
      blendMode: blendMode,
      useDefault: json['useDefault'] ?? true,
    );
  }

  // 获取混合模式的显示名称
  String get blendModeName {
    final option = blendModeOptions.firstWhere(
      (opt) => opt.mode == blendMode,
      orElse: () => blendModeOptions.first,
    );
    return option.name;
  }

  // 获取混合模式的描述
  String get blendModeDescription {
    final option = blendModeOptions.firstWhere(
      (opt) => opt.mode == blendMode,
      orElse: () => blendModeOptions.first,
    );
    return option.description;
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
