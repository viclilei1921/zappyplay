import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:zappyplay/manager/register.dart';
import 'package:zappyplay/manager/video.dart';

class PlaylistPanel extends StatefulWidget {
  const PlaylistPanel({super.key});

  @override
  State<PlaylistPanel> createState() => _PlaylistPanelState();
}

class _PlaylistPanelState extends State<PlaylistPanel> {
  bool _expanded = true;
  final video = getIt<VideoManager>();
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: _expanded ? 280 : 52,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.92),
        border: const Border(left: BorderSide(color: Colors.black26)),
      ),
      child: Column(
        children: [
          IconButton(
            tooltip: _expanded ? '收起播放列表' : '展开播放列表',
            icon: Icon(_expanded ? Icons.chevron_right : Icons.playlist_play),
            onPressed: () => setState(() => _expanded = !_expanded),
          ),
          if (_expanded)
            Expanded(
              child: ValueListenableBuilder<Playlist>(
                valueListenable: video.playlist,
                builder: (_, list, __) {
                  if (list.medias.isEmpty) {
                    return const Center(child: Text('播放列表为空'));
                  }

                  return ListView.separated(
                    itemBuilder: (_, i) {
                      return ListTile(
                        dense: true,
                        leading: const Icon(Icons.movie),
                        title: _expanded
                            ? Text(
                                list.medias[i].uri,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )
                            : null,
                        onTap: () async {
                          await video.jump(i);
                        },
                      );
                    },
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemCount: list.medias.length,
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
