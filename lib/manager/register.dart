import 'package:get_it/get_it.dart';
import 'package:zappyplay/manager/app.dart';
import 'package:zappyplay/manager/video.dart';

GetIt getIt = GetIt.I;

void setupGetIt() {
  getIt.registerSingletonAsync<AppManager>(() async {
    final app = AppManager();
    await app.init();
    return app;
  });

  getIt.registerSingletonAsync<VideoManager>(() async {
    final video = VideoManager();
    await video.init();
    return video;
  });
}
