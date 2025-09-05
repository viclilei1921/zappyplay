enum ZappyRoute { home, settings }

class ZappyRouteState {
  final ZappyRoute currentRoute;
  final String? videoPath;

  ZappyRouteState({required this.currentRoute, this.videoPath});

  ZappyRouteState copyWith({ZappyRoute? currentRoute, String? videoPath}) {
    return ZappyRouteState(
      currentRoute: currentRoute ?? this.currentRoute,
      videoPath: videoPath ?? this.videoPath,
    );
  }
}
