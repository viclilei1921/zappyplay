import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:zappyplay/pages/home.dart';
import 'package:zappyplay/utils/platform.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (isDesktop()) {
    await windowManager.ensureInitialized();
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

  runApp(const HomePage());
}
