import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:zappyplay/l10n/app_localizations.dart';
import 'package:zappyplay/manager/app.dart';
import 'package:zappyplay/manager/register.dart';
import 'package:zappyplay/routes/delegate.dart';
import 'package:zappyplay/routes/parser.dart';

class ZappyApp extends StatefulWidget {
  const ZappyApp({super.key});

  @override
  State<ZappyApp> createState() => _ZappyAppState();
}

class _ZappyAppState extends State<ZappyApp> {
  late final ZappyRouteInformationParser _routeParser;
  late final ZappyRouterDelegate _routerDelegate;
  final app = getIt<AppManager>();

  @override
  void initState() {
    super.initState();
    _routeParser = ZappyRouteInformationParser();
    _routerDelegate = ZappyRouterDelegate();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: app.themeData,
      builder: (context, theme, _) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routeInformationParser: _routeParser,
          routerDelegate: _routerDelegate,
          backButtonDispatcher: RootBackButtonDispatcher(),
          title: 'zappy play',
          locale: app.locale.value,
          theme: theme,
          supportedLocales: const [Locale('zh'), Locale('en')],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
        );
      },
    );
  }
}
