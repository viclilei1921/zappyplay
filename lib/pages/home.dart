import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final Function(String) onNavigateToVideo;
  const HomePage({super.key, required this.onNavigateToVideo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('zappy play')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            onNavigateToVideo(
              'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',
            );
          },
          child: const Text('play video'),
        ),
      ),
    );
  }
}
