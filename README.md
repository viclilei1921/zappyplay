# ZappyPlay
通过写一个桌面视频播放器，来学习flutter

## 常用命令

升级 Flutter SDK

```shell
flutter upgrade
```

把 `pubspec.yaml` 文件里列出的所有依赖更新到 **最新的兼容版本**

```shell
flutter pub upgrade
```

把 `pubspec.yaml` 文件里列出的所有依赖更新到 **最新的版本**

```shell
flutter pub upgrade --major-versions
```

## 开始使用 Flutter 开发桌面应用

过一次性的配置更改来配置桌面支持。

```shell
flutter config --enable-windows-desktop # for the Windows runner
flutter config --enable-macos-desktop   # for the macOS runner
flutter config --enable-linux-desktop   # for the Linux runner
```

确认是否已启用桌面版 Flutter

```shell
flutter devices
```

创建项目

```shell
flutter create
```

删除 Android、iOS 和网络支持文件。编写 Flutter 桌面应用时不需要使用这些文件。删除这些文件有助于避免在此期间意外地运行错误的变体。

```shell
# mac or linux
rm -r android ios web

# windows
rmdir /s /q android
rmdir /s /q ios
rmdir /s /q web
```

## Navigator

Page: 表示路由栈中各个页面的不可变对象，通常使用`MaterialPage`或者`CupertinaPage`;

Router: 用来配置要展示的页面列表，通常，该页面列表会根据系统或者应用程序的状态改变而改变。除了直接使用`Router`本身外还可以使用`MaterialApp.router()`来创建;

RouterDelegate: 定义应用程序中路由的行为，例如`Router`如何知道应用程序的变化以及如何响应，监听状态，并使用当前列表来构建Pages;

RouteInformationParset: 可缺省，主要应用于web;

BackButtonDispatcher: 响应后退按钮，并通知Router;
