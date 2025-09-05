import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:zappyplay/manager/register.dart';
import 'package:zappyplay/manager/video.dart';

class VideoView extends StatelessWidget {
  const VideoView({super.key});

  @override
  Widget build(BuildContext context) {
    final video = getIt<VideoManager>();

    return ValueListenableBuilder(
      valueListenable: video.id,
      builder: (context, id, child) {
        if (id == null || !video.hasVideo.value) {
          return Center(
            child: ElevatedButton(
              onPressed: () {
                _pickVideos(context);
              },
              child: const Text('添加文件'),
            ),
          );
        }

        return Center(
          child: FittedBox(
            fit: BoxFit.contain, // 保持比例，最大化显示
            child: SizedBox(
              width: video.width.value.toDouble(),
              height: video.height.value.toDouble(),
              child: Texture(textureId: id, filterQuality: FilterQuality.high),
            ),
          ),
        );
      },
    );
  }

  /// 选择视频
  Future<void> _pickVideos(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'mp4',
        'mkv',
        'avi',
        'mov',
        'flv',
        'wmv',
        'mpg',
        'mpeg',
        '3gp',
        'm4v',
      ],
      allowMultiple: true,
    );

    if (result != null && result.files.isNotEmpty) {
      final video = getIt<VideoManager>();
      final paths = result.paths.whereType<String>().toList();
      video.addPlayItems(paths);
    }
  }
}
