import 'dart:async';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:zappyplay/manager/app.dart';
import 'package:zappyplay/manager/register.dart';
import 'package:zappyplay/manager/video.dart';
import 'package:zappyplay/models/window_state.dart';
import 'package:zappyplay/utils/file.dart';
import 'package:zappyplay/widgets/control.dart';
import 'package:zappyplay/widgets/playlist.dart';
import 'package:zappyplay/widgets/titlebar.dart';
import 'package:zappyplay/widgets/video.dart';

//
class HomePage extends StatefulWidget {
  final Function() onNavigateToSettings;
  const HomePage({super.key, required this.onNavigateToSettings});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _showUI = true;
  Timer? _hideTimer;

  void _onPointerEnter() {
    setState(() => _showUI = true);
    _hideTimer?.cancel();
  }

  void _onPointerExit() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(milliseconds: 50), () {
      if (mounted) setState(() => _showUI = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: MouseRegion(
        onEnter: (_) => _onPointerEnter(),
        onExit: (_) => _onPointerExit(),
        child: Stack(
          children: [
            DropTarget(
              onDragDone: _dragDone,
              child: KeyboardListener(
                focusNode: FocusNode()..requestFocus(),
                onKeyEvent: _handleKey,
                child: Positioned.fill(child: const VideoView()),
              ),
            ),

            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AnimatedOpacity(
                opacity: _showUI ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: CustomTitlebar(
                  onNavigateToSettings: widget.onNavigateToSettings,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: AnimatedOpacity(
                opacity: _showUI ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, Colors.black54],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: PlayerControls(),
                ),
              ),
            ),
            Positioned(
              top: 28,
              right: 0,
              bottom: 64,
              child: AnimatedOpacity(
                opacity: _showUI ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: const PlaylistPanel(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _dragDone(DropDoneDetails details) {
    List<String> paths = [];
    for (int i = 0; i < details.files.length; i++) {
      final ext = extension(details.files[i].path).toLowerCase();

      if (isVideo(ext)) {
        paths.add(details.files[i].path);
      }
    }

    if (paths.isEmpty) {
      return;
    }

    final video = getIt<VideoManager>();
    if (video.playlist.value.medias.isNotEmpty) {
      for (var path in paths) {
        video.addPlayItem(path);
      }
      return;
    }
    video.addPlayItems(paths);
  }

  bool _handleKey(KeyEvent event) {
    if (event is! KeyDownEvent) {
      return false;
    }

    final video = getIt<VideoManager>();
    final app = getIt<AppManager>();

    if (event.logicalKey.keyLabel == 'Escape') {
      if (app.windowStatus.value == WindowState.fullscreen) {
        app.fullscreen(false);
      }
      return true;
    }

    if (event.logicalKey.keyLabel == 'Enter' ||
        event.logicalKey.keyLabel == 'F') {
      app.fullscreen(app.windowStatus.value != WindowState.fullscreen);
      return true;
    }

    if (video.hasVideo.value == false) {
      return false;
    }

    switch (event.logicalKey.keyLabel) {
      case ' ':
        if (video.playing.value) {
          video.pause();
        } else {
          video.play();
        }
        break;
      case 'Arrow Left':
        video.seek(video.position.value - const Duration(seconds: 5));
        break;
      case 'Arrow Right':
        video.seek(video.position.value + const Duration(seconds: 5));
        break;
      case 'Arrow Up':
        video.setVolume(video.volume.value + 5);
        break;
      case 'Arrow Down':
        video.setVolume(video.volume.value - 5);
        break;
    }

    return true;
  }
}
