//dart run build_runner build

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'settings.g.dart';

@JsonSerializable()
class AppSettings {
  // -------- Appearance Settings -----------
  /// 字体
  String locale;
  String? font;
  ThemeMode themeMode;
  int themeCode;
  // -------- Appearance Settings -----------

  // ----------- Player Settings ------------
  bool autoPlay;
  int listMode;
  double defaultVolume;
  double defaultSpeed;
  bool defaultMusicMode;
  bool playAfterExit;
  Map<String, String> mpvProperties;
  Map<String, String> mpvOptions;
  bool enableMpvConfig;
  bool useDefaultKeyBinding;
  String mpvConfigPath;
  int mpvOsdLevel;
  // ----------- Player Settings ------------

  AppSettings({
    // Display Settings,
    this.locale = 'zh',
    this.font,
    this.themeMode = ThemeMode.system,
    this.themeCode = 4,

    // Player Settings
    this.autoPlay = true,
    this.listMode = 0,
    this.defaultVolume = 100,
    this.defaultSpeed = 1,
    this.defaultMusicMode = false,
    this.playAfterExit = true,
    this.mpvOptions = const {},
    this.mpvProperties = const {},
    this.enableMpvConfig = true,
    this.useDefaultKeyBinding = true,
    this.mpvConfigPath = '',
    this.mpvOsdLevel = 0,
  });

  factory AppSettings.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$AppSettingsToJson(this);
}
