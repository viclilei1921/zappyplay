import 'package:flutter/material.dart';
import 'package:zappyplay/models/app_state.dart';

class ZappyRouteInformationParser
    extends RouteInformationParser<ZappyRouteState> {
  @override
  Future<ZappyRouteState> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    final pathSegments = routeInformation.uri.pathSegments;

    if (pathSegments.isEmpty) {
      return ZappyRouteState(currentRoute: ZappyRoute.home);
    }

    if (pathSegments.length == 2 && pathSegments[0] == 'settings') {
      return ZappyRouteState(currentRoute: ZappyRoute.settings);
    }

    return ZappyRouteState(currentRoute: ZappyRoute.home);
  }

  @override
  RouteInformation? restoreRouteInformation(ZappyRouteState configuration) {
    if (configuration.currentRoute == ZappyRoute.settings) {
      return RouteInformation(uri: Uri.parse('/settings'));
    }

    return RouteInformation(uri: Uri.parse('/'));
  }
}
