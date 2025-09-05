import 'package:flutter/material.dart';
import 'package:zappyplay/models/app_state.dart';
import 'package:zappyplay/pages/settings.dart';
import 'package:zappyplay/pages/home.dart';

class ZappyRouterDelegate extends RouterDelegate<ZappyRouteState>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<ZappyRouteState> {
  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  ZappyRouteState _state = ZappyRouteState(currentRoute: ZappyRoute.home);

  ZappyRouteState get currentState => _state;

  List<MaterialPage> pages = [];

  void goHome() {
    _state = ZappyRouteState(currentRoute: ZappyRoute.home);
    notifyListeners();
  }

  void goSettings() {
    _state = ZappyRouteState(currentRoute: ZappyRoute.settings);
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    pages = [
      MaterialPage(child: HomePage(onNavigateToSettings: _navigateToSettings)),
      if (_state.currentRoute == ZappyRoute.settings)
        MaterialPage(child: SettingsPage()),
    ];

    return Navigator(
      key: navigatorKey,
      pages: pages,
      onDidRemovePage: (Page removedPage) {
        if (_state.currentRoute == ZappyRoute.settings) {
          // 在这里同步移除页面状态
          _state = ZappyRouteState(currentRoute: ZappyRoute.home);
          notifyListeners();
        }
      },
    );
  }

  @override
  Future<bool> popRoute() async {
    // 当用户按下返回键（或关闭页面）时调用
    if (_state.currentRoute != ZappyRoute.home) {
      _state = ZappyRouteState(currentRoute: ZappyRoute.home);
      notifyListeners();
      return true;
    }

    // 已经是首页，无法再返回
    return false;
  }

  @override
  Future<void> setNewRoutePath(ZappyRouteState configuration) async {
    _state = configuration;
  }

  void _navigateToSettings() {
    _state = ZappyRouteState(currentRoute: ZappyRoute.settings);
    notifyListeners();
  }
}
