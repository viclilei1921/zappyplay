import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:zappyplay/manager/register.dart';
import 'package:zappyplay/manager/video.dart';
// import 'package:zappyplay/widgets/titlebar.dart';

class HomePage extends StatelessWidget {
  final Function(String) onNavigateToVideo;
  const HomePage({super.key, required this.onNavigateToVideo});

  @override
  Widget build(BuildContext context) {
    final video = getIt<VideoManager>();

    return Scaffold(
      appBar: null,
      body: Row(
        children: [
          // Titlebar(),
          ValueListenableBuilder<int?>(
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

              return FittedBox(
                child: SizedBox(
                  width: video.width.value.toDouble(),
                  height: video.height.value.toDouble(),
                  child: Texture(
                    textureId: id,
                    filterQuality: FilterQuality.high,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// 选择视频
  Future<void> _pickVideos(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp4', 'mkv', 'avi', 'mov'],
      allowMultiple: true,
    );

    if (result != null && result.files.isNotEmpty) {
      final video = getIt<VideoManager>();
      final paths = result.paths.whereType<String>().toList();
      video.addPlayItems(paths);
    }
  }
}
