import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:zappyplay/manager/register.dart';
import 'package:zappyplay/manager/video.dart';

class PlayerControls extends StatelessWidget {
  const PlayerControls({super.key});

  @override
  Widget build(BuildContext context) {
    final video = getIt<VideoManager>();

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      color: Colors.black54,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ValueListenableBuilder<Duration>(
            valueListenable: video.position,
            builder: (context, position, child) {
              final total = video.duration.value;
              final progress = total.inMilliseconds == 0
                  ? 0.0
                  : position.inMilliseconds / total.inMilliseconds;
              return Column(
                children: [
                  Slider(
                    value: progress.clamp(0, 1),
                    onChanged: (v) {
                      final ms = (v * total.inMilliseconds).round();
                      video.seek(Duration(milliseconds: ms));
                    },
                  ),
                  Row(
                    children: [
                      Text(
                        _fmt(position),
                        style: const TextStyle(color: Colors.white),
                      ),
                      const Spacer(),
                      Text(
                        _fmt(total),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          Row(
            children: [
              ValueListenableBuilder(
                valueListenable: video.playing,
                builder: (context, playing, child) {
                  return IconButton(
                    icon: Icon(
                      playing ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                    ),
                    tooltip: playing ? '暂停' : '播放',
                    onPressed: () {
                      if (playing) {
                        video.pause();
                      } else {
                        video.play();
                      }
                    },
                  );
                },
              ),
              IconButton(
                tooltip: '截图',
                onPressed: () => _capture(context),
                icon: const Icon(Icons.camera_alt, color: Colors.white),
              ),
              const SizedBox(width: 8),
              Icon(Icons.volume_up, color: Colors.white),
              SizedBox(
                width: 160,
                child: ValueListenableBuilder(
                  valueListenable: video.volume,
                  builder: (_, volume, __) {
                    return Slider(
                      value: volume,
                      min: 0,
                      max: 100,
                      onChanged: (v) {
                        video.setVolume(v);
                      },
                    );
                  },
                ),
              ),
              SizedBox(width: 12),
              PopupMenuButton<double>(
                tooltip: '播放速度',
                initialValue: video.rate.value,
                itemBuilder: (context) => const [0.5, 0.75, 1, 1.5, 2]
                    .map(
                      (r) => PopupMenuItem<double>(
                        value: r.toDouble(),
                        child: Text('${r}x'),
                      ),
                    )
                    .toList(),
                onSelected: (v) => video.setRate(v),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ValueListenableBuilder(
                    valueListenable: video.rate,
                    builder: (_, rate, __) => Text(
                      '${rate}x',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                tooltip: '音轨',
                onPressed: () async {
                  final tracks = video.tracks.value.audio;
                  if (!context.mounted) return;
                  showModalBottomSheet(
                    context: context,
                    builder: (_) => ListView.builder(
                      itemCount: tracks.length,
                      itemBuilder: (context, index) => ListTile(
                        title: Text(tracks[index].id),
                        onTap: () {
                          video.selectAudioTrack(index);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.audiotrack, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _capture(BuildContext context) async {
    final video = getIt<VideoManager>();

    final picData = await video.screenshot();
    if (picData == null) {
      return;
    }
    final dir = await getTemporaryDirectory();
    final file = File(
      '${dir.path}/screenshot_${DateTime.now().millisecondsSinceEpoch}.png',
    );
    await file.writeAsBytes(picData);

    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('已保存截图: ${file.path}')));
    }
  }

  String _fmt(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    final h = d.inHours,
        m = d.inMinutes.remainder(60),
        s = d.inSeconds.remainder(60);
    return h > 0 ? '${two(h)}:${two(m)}:${two(s)}' : '${two(m)}:${two(s)}';
  }
}
