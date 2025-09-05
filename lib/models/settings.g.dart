// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) => AppSettings(
  locale: json['locale'] as String? ?? '',
  font: json['font'] as String? ?? '',
  themeMode:
      $enumDecodeNullable(_$ThemeModeEnumMap, json['themeMode']) ??
      ThemeMode.system,
  themeCode: (json['themeCode'] as num?)?.toInt() ?? 4,
  autoPlay: json['autoPlay'] as bool? ?? true,
  listMode: (json['listMode'] as num?)?.toInt() ?? 0,
  defaultVolume: (json['defaultVolume'] as num?)?.toDouble() ?? 100,
  defaultSpeed: (json['defaultSpeed'] as num?)?.toDouble() ?? 1,
  defaultMusicMode: json['defaultMusicMode'] as bool? ?? false,
  playAfterExit: json['playAfterExit'] as bool? ?? true,
  mpvOptions:
      (json['mpvOptions'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ) ??
      const {},
  mpvProperties:
      (json['mpvProperties'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ) ??
      const {},
  enableMpvConfig: json['enableMpvConfig'] as bool? ?? true,
  useDefaultKeyBinding: json['useDefaultKeyBinding'] as bool? ?? true,
  mpvConfigPath: json['mpvConfigPath'] as String? ?? '',
  mpvOsdLevel: (json['mpvOsdLevel'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$AppSettingsToJson(AppSettings instance) =>
    <String, dynamic>{
      'locale': instance.locale,
      'font': instance.font,
      'themeMode': _$ThemeModeEnumMap[instance.themeMode]!,
      'themeCode': instance.themeCode,
      'autoPlay': instance.autoPlay,
      'listMode': instance.listMode,
      'defaultVolume': instance.defaultVolume,
      'defaultSpeed': instance.defaultSpeed,
      'defaultMusicMode': instance.defaultMusicMode,
      'playAfterExit': instance.playAfterExit,
      'mpvOptions': instance.mpvOptions,
      'mpvProperties': instance.mpvProperties,
      'enableMpvConfig': instance.enableMpvConfig,
      'useDefaultKeyBinding': instance.useDefaultKeyBinding,
      'mpvConfigPath': instance.mpvConfigPath,
      'mpvOsdLevel': instance.mpvOsdLevel,
    };

const _$ThemeModeEnumMap = {
  ThemeMode.system: 'system',
  ThemeMode.light: 'light',
  ThemeMode.dark: 'dark',
};
