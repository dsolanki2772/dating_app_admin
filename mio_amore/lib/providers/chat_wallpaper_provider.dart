import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mio_amore/helpers/constants.dart';
import 'package:mio_amore/models/chat_wallpaper_model.dart';

final chatWallpaperProvider =
    ChangeNotifierProvider<ChatWallpaperProvider>((ref) {
  return ChatWallpaperProvider();
});

class ChatWallpaperProvider extends ChangeNotifier {
  Future<void> setWallpaper(ChatWallpaperModel? model) async {
    final _box = Hive.box(HiveConstants.hiveBox);
    await _box.put(HiveConstants.chatWallpaper, model?.toJson());
    notifyListeners();
  }

  ChatWallpaperModel? getWallpaper() {
    final _box = Hive.box(HiveConstants.hiveBox);
    final _chatWallpaperJson =
        _box.get(HiveConstants.chatWallpaper, defaultValue: null);

    return _chatWallpaperJson != null
        ? ChatWallpaperModel.fromJson(_chatWallpaperJson)
        : null;
  }
}
