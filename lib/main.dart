import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:window_manager/window_manager.dart';
import 'package:zappyplay/app.dart';
import 'package:zappyplay/manager/register.dart';
import 'package:zappyplay/utils/platform.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();

  setupGetIt();

  if (isDesktop()) {
    await windowManager.ensureInitialized();
    await windowManager.setAsFrameless();
    WindowOptions windowOptions = const WindowOptions(
      size: Size(800, 600),
      minimumSize: Size(700, 500),
      backgroundColor: Colors.transparent,
      skipTaskbar: false, // 窗口是否在任务栏显示
      titleBarStyle: TitleBarStyle.hidden,
      center: true,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  runApp(const ZappyApp());
}
