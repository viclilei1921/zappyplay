import 'dart:math';
import 'dart:typed_data';

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
  final volume = ValueNotifier<double>(100.0);

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
  Future<void> addMedia(String source) async {
    await _player.open(Media(source));
  }

  /// 添加视频到列表
  Future<void> addPlayItem(String path) async {
    await _player.add(Media(path));
  }

  /// 批量添加视频
  Future<void> addPlayItems(List<String> paths) async {
    final playList = Playlist(paths.map((e) => Media(e)).toList(), index: 0);
    await _player.open(playList);
  }

  Future<void> remove(int index) async {
    await _player.remove(index);
  }

  /// 播放列表中视频
  /// [index] 索引
  Future<void> jump(int index) async {
    if (playlist.value.medias.length <= 1) {
      return;
    }

    if (index < 0 || index >= playlist.value.medias.length) {
      return;
    }

    await _player.jump(index);
  }

  /// 上一首
  Future<void> previous() async {
    await _player.previous();
  }

  /// 下一首
  Future<void> next() async {
    await _player.next();
  }

  /// 移动播放列表顺序
  Future<void> move(int from, int to) async {
    await _player.move(from, to);
  }

  /// 停止
  Future<void> stop() async {
    await _player.stop();
  }

  /// 播放
  Future<void> play() async {
    await _player.play();
  }

  /// 暂停
  Future<void> pause() async {
    await _player.pause();
  }

  /// 跳转
  Future<void> seek(Duration position) async {
    // ignore: avoid_print
    print(position);
    // ignore: avoid_print
    print(duration.value);
    await _player.seek(position);
  }

  /// 设置音量
  /// [vol] 音量
  Future<void> setVolume(double vol) async {
    await _player.setVolume(vol);
  }

  /// 设置播放速度
  /// [rate] 播放速度
  Future<void> setRate(double rate) async {
    await _player.setRate(rate);
  }

  /// 选择音频轨道
  Future<void> selectAudioTrack(int index) async {
    final audioTracks = tracks.value.audio;
    if (audioTracks.length == 1) {
      // 只有一个的时候不需要选择
      return;
    }
    if (index < 0 || index >= audioTracks.length) return;

    final track = audioTracks[index];
    await _player.setAudioTrack(track);
  }

  /// 选择视频轨道
  Future<void> selectVideoTrack(int index) async {
    final videoTracks = tracks.value.video;
    if (videoTracks.length == 1) {
      // 只有一个的时候不需要选择
      return;
    }
    if (index < 0 || index >= videoTracks.length) return;

    final track = videoTracks[index];
    await _player.setVideoTrack(track);
  }

  /// 选择字幕轨道
  Future<void> selectSubtitleTrack(int index) async {
    final subtitleTracks = tracks.value.subtitle;
    if (subtitleTracks.length == 1) {
      // 只有一个的时候不需要选择
      return;
    }
    if (index < 0 || index >= subtitleTracks.length) return;

    final track = subtitleTracks[index];
    await _player.setSubtitleTrack(track);
  }

  /// 截图
  Future<Uint8List?> screenshot() => _player.screenshot(format: 'image/png');

  int voWidth = 0;
  int voHeight = 0;

  /// 根据视频的原始尺寸（voWidth 和 voHeight）
  ///
  /// 当前尺寸（w 和 h）调整视频播放器的大小。
  ///
  /// 它计算一个缩放因子（fac）来保持视频的长宽比
  Future<void> refreshVO() async {
    var voInfo = _player.state.videoParams;
    int w = voInfo.dw ?? 1, h = voInfo.dh ?? 1;
    double fac = min(voWidth / w, voHeight / h);
    await controller.setSize(width: (w * fac) ~/ 1, height: (h * fac) ~/ 1);
  }

  Future<void> restoreVO() async {
    await controller.setSize();
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
