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

    if (pathSegments.length == 2 && pathSegments[0] == 'video') {
      return ZappyRouteState(
        currentRoute: ZappyRoute.video,
        videoPath: pathSegments[1],
      );
    }

    return ZappyRouteState(currentRoute: ZappyRoute.home);
  }

  @override
  RouteInformation? restoreRouteInformation(ZappyRouteState configuration) {
    if (configuration.currentRoute == ZappyRoute.video &&
        configuration.videoPath != null) {
      return RouteInformation(
        uri: Uri.parse('/video/${configuration.videoPath}'),
      );
    }

    return RouteInformation(uri: Uri.parse('/'));
  }
}
