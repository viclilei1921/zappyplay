import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:zappyplay/manager/app.dart';
import 'package:zappyplay/manager/register.dart';
import 'package:zappyplay/manager/video.dart';
import 'package:zappyplay/models/window_state.dart';

class CustomTitlebar extends StatelessWidget {
  final Function()? onNavigateToSettings;
  const CustomTitlebar({super.key, this.onNavigateToSettings});

  @override
  Widget build(BuildContext context) {
    final video = getIt<VideoManager>();
    final app = getIt<AppManager>();

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
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
      child: Container(
        height: 28,
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.85),
        child: Row(
          children: [
            const Icon(CupertinoIcons.play_rectangle, size: 10),
            const SizedBox(width: 8),
            Expanded(
              child: ValueListenableBuilder<String>(
                valueListenable: video.playingTitle,
                builder: (context, title, _) {
                  return Text(
                    title,
                    style: TextStyle(fontSize: 11),
                    overflow: TextOverflow.ellipsis,
                  );
                },
              ),
            ),
            IconButton(
              onPressed: () {
                onNavigateToSettings?.call();
              },
              icon: const Icon(CupertinoIcons.gear, size: 10),
            ),
            IconButton(
              onPressed: () {
                app.minimize();
              },
              iconSize: 10,
              icon: const Icon(CupertinoIcons.minus),
            ),
            ValueListenableBuilder(
              valueListenable: app.windowStatus,
              builder: (context, status, _) {
                return IconButton(
                  onPressed: () {
                    if (status == WindowState.maximized) {
                      app.restore();
                    } else {
                      app.maximize();
                    }
                  },
                  iconSize: 10,
                  icon: Icon(
                    status == WindowState.maximized
                        ? CupertinoIcons.square_on_square
                        : CupertinoIcons.square,
                  ),
                );
              },
            ),
            IconButton(
              onPressed: () {
                app.close();
              },
              iconSize: 12,
              icon: const Icon(CupertinoIcons.multiply),
            ),
          ],
        ),
      ),
    );
  }
}
