import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:zappyplay/models/settings.dart';

class AppManager {
  /// 软件地址
  late final String dataPath;

  /// 配置
  late AppSettings settings;

  Future<void> init() async {
    dataPath = (await getApplicationSupportDirectory()).path;

    await loadSettings();
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
}
