import 'package:flutter/material.dart';
import 'package:zappyplay/models/app_state.dart';
import 'package:zappyplay/pages/video.dart';
import 'package:zappyplay/pages/home.dart';

class ZappyRouterDelegate extends RouterDelegate<ZappyRouteState>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<ZappyRouteState> {
  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  ZappyRouteState _state = ZappyRouteState(currentRoute: ZappyRoute.home);

  ZappyRouteState get currentState => _state;

  List<MaterialPage> pages = [];

  @override
  Widget build(BuildContext context) {
    pages = [
      MaterialPage(child: HomePage(onNavigateToVideo: _navigateToVideo)),
      if (_state.currentRoute == ZappyRoute.video && _state.videoPath != null)
        MaterialPage(child: VideoPage(videoPath: _state.videoPath!)),
    ];

    return Navigator(key: navigatorKey, pages: pages);
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

  void _navigateToVideo(String videoPath) {
    _state = ZappyRouteState(
      currentRoute: ZappyRoute.video,
      videoPath: videoPath,
    );
    notifyListeners();
  }
}
