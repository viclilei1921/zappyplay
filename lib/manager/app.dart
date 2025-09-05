import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:window_manager/window_manager.dart';
import 'package:zappyplay/models/settings.dart';
import 'package:zappyplay/models/window_state.dart';
import 'package:zappyplay/utils/constants.dart';

class AppManager {
  /// 软件地址
  late final String dataPath;

  /// 配置
  late AppSettings settings;

  /// 主题
  late ValueNotifier<ThemeData> themeData;

  /// 语言
  late ValueNotifier<Locale> locale;

  final windowStatus = ValueNotifier<WindowState>(WindowState.normal);

  final windowRect = ValueNotifier<Rect>(const Rect.fromLTWH(0, 0, 800, 600));

  Future<void> init() async {
    dataPath = (await getApplicationSupportDirectory()).path;

    await loadSettings();

    themeData = ValueNotifier<ThemeData>(
      _getThemeData(
        themeMode: settings.themeMode,
        themeCode: settings.themeCode,
      ),
    );
    locale = ValueNotifier<Locale>(_getLocale(settings.locale));
  }

  /// 加载配置
  Future<void> loadSettings() async {
    var settingsPath = "$dataPath/config/settings.json";
    var fp = File(settingsPath);
    if (!await fp.exists()) {
      await fp.create(recursive: true);
      var data = AppSettings().toJson();
      var str = jsonEncode(data);
      await fp.writeAsString(str);
    }
    settings = AppSettings.fromJson(jsonDecode(await fp.readAsString()));
  }

  /// 保存配置
  Future<void> saveSettings() async {
    var settingsPath = "$dataPath/config/settings.json";
    var fp = File(settingsPath);
    var data = settings.toJson();
    var str = jsonEncode(data);
    await fp.writeAsString(str);
  }

  /// 最大化
  Future<void> maximize() async {
    windowStatus.value = WindowState.maximized;
    await windowManager.maximize();
    windowManager.getBounds();
  }

  Future<void> fullscreen(bool isFullscreen) async {
    await windowManager.setFullScreen(isFullscreen);
    isFullscreen = await windowManager.isFullScreen();

    if (isFullscreen) {
      windowStatus.value = WindowState.fullscreen;
    } else {
      windowStatus.value = WindowState.normal;
    }
  }

  /// 最小化
  Future<void> minimize() async {
    windowStatus.value = WindowState.minimized;
    await windowManager.minimize();
  }

  /// 还原
  Future<void> restore() async {
    windowStatus.value = WindowState.normal;
    await windowManager.restore();
  }

  /// 关闭
  Future<void> close() async {
    await windowManager.close();
  }

  /// 设置主题
  setTheme({ThemeMode? themeMode, int? themeCode}) {
    if (themeMode != null) {
      settings.themeMode = themeMode;
    }
    if (themeCode != null) {
      settings.themeCode = themeCode;
    }
    themeData.value = _getThemeData(
      themeMode: settings.themeMode,
      themeCode: settings.themeCode,
    );
  }

  /// 设置语言
  setLocale(String? lang) {
    if (lang != null) {
      settings.locale = lang;
    }

    locale.value = _getLocale(settings.locale);
  }

  ThemeData _getThemeData({
    required ThemeMode themeMode,
    required int themeCode,
  }) {
    final Brightness b = themeMode == ThemeMode.dark
        ? Brightness.dark
        : Brightness.light;
    final Color seed = themeColors[themeCode];

    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: seed,
      brightness: b,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }

  Locale _getLocale(String lang) {
    switch (lang) {
      case 'zh':
        return const Locale('zh', 'CN');
      case 'en':
        return const Locale('en', 'US');
      default:
        return const Locale('zh', 'CN');
    }
  }
}
