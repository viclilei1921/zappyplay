import 'dart:math';

import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:path/path.dart';

class VideoManager {
  /// 播放器
  late final Player _player;

  /// 控制器
  late final VideoController _controller;

  /// 是否有视频
  final hasVideo = ValueNotifier<bool>(false);

  /// 正在播放的文件名
  final playingTitle = ValueNotifier<String>('Not Playing');

  /// 播放列表
  final playlist = ValueNotifier<Playlist>(Playlist([], index: 0));

  /// 是否正在播放
  final playing = ValueNotifier<bool>(false);

  /// 是否播放完成
  final completed = ValueNotifier<bool>(false);

  /// 当前播放时间
  final position = ValueNotifier<Duration>(Duration.zero);

  /// 视频总时长
  final duration = ValueNotifier<Duration>(Duration.zero);

  /// 音量
  final volume = ValueNotifier<double>(1.0);

  /// 播放速度
  final rate = ValueNotifier<double>(1.0);

  /// 音调
  final pitch = ValueNotifier<double>(1.0);

  /// 缓冲
  final buffering = ValueNotifier<bool>(false);

  /// 缓冲时长
  final buffer = ValueNotifier<Duration>(Duration.zero);

  /// 播放模式
  final playlistMode = ValueNotifier<PlaylistMode>(PlaylistMode.none);

  /// 音频参数
  final audioParams = ValueNotifier<AudioParams>(AudioParams());

  /// 视频参数
  final videoParams = ValueNotifier<VideoParams>(VideoParams());

  /// 音频码率
  final audioBitrate = ValueNotifier<double?>(0);

  /// 当前选择的视频、音频和字幕轨道
  final track = ValueNotifier<Track>(Track());

  /// 当前可用的视频、音频和字幕轨道
  final tracks = ValueNotifier<Tracks>(Tracks());

  /// 视频宽度
  final width = ValueNotifier<int>(0);

  /// 视频高度
  final height = ValueNotifier<int>(0);

  /// 错误
  final error = ValueNotifier<String>('');

  Player get player {
    return _player;
  }

  VideoController get controller {
    return _controller;
  }

  ValueNotifier<int?> get id {
    return _controller.id;
  }

  Future<void> init() async {
    _player = Player();
    _controller = VideoController(_player);

    _steamListener();
  }

  /// 打开[media]视频
  void addMedia(String source) {
    _player.open(Media(source));
  }

  /// 批量添加视频
  void addPlayItems(List<String> paths) async {
    final playList = Playlist(paths.map((e) => Media(e)).toList(), index: 0);
    await _player.open(playList);
  }

  int voWidth = 0;
  int voHeight = 0;

  /// 根据视频的原始尺寸（voWidth 和 voHeight）
  ///
  /// 当前尺寸（w 和 h）调整视频播放器的大小。
  ///
  /// 它计算一个缩放因子（fac）来保持视频的长宽比
  void refreshVO() {
    var voInfo = _player.state.videoParams;
    int w = voInfo.dw ?? 1, h = voInfo.dh ?? 1;
    double fac = min(voWidth / w, voHeight / h);
    controller.setSize(width: (w * fac) ~/ 1, height: (h * fac) ~/ 1);
  }

  void restoreVO() {
    controller.setSize();
  }

  /// steam监听
  void _steamListener() {
    _player.stream.playlist.listen((Playlist ePlaylist) {
      playlist.value = ePlaylist;

      if (ePlaylist.medias.isNotEmpty) {
        var src = ePlaylist.medias[ePlaylist.index].uri;
        playingTitle.value = basenameWithoutExtension(src);
        hasVideo.value = true;
        return;
      }

      playingTitle.value = 'Not Playing';
      hasVideo.value = false;
    });

    _player.stream.playing.listen((bool ePlaying) {
      playing.value = ePlaying;
    });

    _player.stream.completed.listen((bool eCompleted) {
      completed.value = eCompleted;
    });

    _player.stream.position.listen((Duration ePosition) {
      position.value = ePosition;
    });

    _player.stream.duration.listen((Duration eDuration) {
      duration.value = eDuration;
    });

    _player.stream.volume.listen((double eVolume) {
      volume.value = eVolume;
    });

    _player.stream.rate.listen((double eRate) {
      rate.value = eRate;
    });

    _player.stream.pitch.listen((double ePitch) {
      pitch.value = ePitch;
    });

    _player.stream.buffering.listen((bool eBuffering) {
      buffering.value = eBuffering;
    });

    _player.stream.buffer.listen((Duration eBuffer) {
      buffer.value = eBuffer;
    });

    _player.stream.playlistMode.listen((PlaylistMode ePlaylistMode) {
      playlistMode.value = ePlaylistMode;
    });

    _player.stream.audioParams.listen((AudioParams eAudioParams) {
      audioParams.value = eAudioParams;
    });

    _player.stream.videoParams.listen((VideoParams eVideoParams) {
      videoParams.value = eVideoParams;
    });

    _player.stream.audioBitrate.listen((double? eAudioBitrate) {
      audioBitrate.value = eAudioBitrate;
    });

    _player.stream.tracks.listen((Tracks eTracks) {
      tracks.value = eTracks;
    });

    _player.stream.track.listen((Track eTrack) {
      track.value = eTrack;
    });

    _player.stream.width.listen((int? eWidth) {
      width.value = eWidth ?? 0;
    });

    _player.stream.height.listen((int? eHeight) {
      height.value = eHeight ?? 0;
    });

    _player.stream.error.listen((String eError) {
      error.value = eError;
    });
  }
}
