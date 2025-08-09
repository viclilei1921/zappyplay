import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class Titlebar extends StatelessWidget {
  const Titlebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      color: Colors.transparent,
      child: GestureDetector(
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
        child: Row(
          children: [
            Spacer(),
            Text("Zappy play"),
            Spacer(),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    windowManager.minimize();
                  },
                  iconSize: 10,
                  icon: const Icon(CupertinoIcons.minus),
                ),
                IconButton(
                  onPressed: () {
                    windowManager.maximize();
                  },
                  iconSize: 10,
                  icon: const Icon(CupertinoIcons.square), // square_on_square
                ),
                IconButton(
                  onPressed: () {
                    windowManager.close();
                  },
                  iconSize: 10,
                  icon: const Icon(CupertinoIcons.multiply),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
