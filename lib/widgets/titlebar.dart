import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

PreferredSizeWidget? buildTitleBar(BuildContext context) {
  return AppBar(
    scrolledUnderElevation: 0,
    toolbarHeight: 30,
    titleSpacing: 12,
    title: GestureDetector(
      behavior: HitTestBehavior.translucent,
      onPanStart: (details) {
        windowManager.startDragging();
      },
      onDoubleTap: () async {
        if (await windowManager.isMaximized()) {
          windowManager.unmaximize();
        } else {
          windowManager.maximize();
        }
      },
      child: Row(children: [Text('zappy play')]),
    ),
    actions: [
      IconButton(
        onPressed: () async {
          windowManager.minimize();
        },
        icon: const Icon(Icons.arrow_downward),
      ),
    ],
  );
}
