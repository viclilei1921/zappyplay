import 'dart:io';

/// 是否为桌面环境
bool isDesktop() {
  return Platform.isWindows || Platform.isMacOS || Platform.isLinux;
}
