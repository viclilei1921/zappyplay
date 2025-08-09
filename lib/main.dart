import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:window_manager/window_manager.dart';
import 'package:zappyplay/routes/delegate.dart';
import 'package:zappyplay/routes/parser.dart';
import 'package:zappyplay/utils/platform.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();

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

class ZappyApp extends StatelessWidget {
  const ZappyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final routeParser = ZappyRouteInformationParser();
    final routerDelegate = ZappyRouterDelegate();

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routeInformationParser: routeParser,
      routerDelegate: routerDelegate,
      title: 'zappy play',
      theme: ThemeData(primaryColor: Colors.blue),
    );
  }
}
