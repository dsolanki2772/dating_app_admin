import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mio_amore/config/config.dart';
import 'package:mio_amore/helpers/constants.dart';
import 'package:mio_amore/helpers/media_picker_helper.dart';
import 'package:mio_amore/models/chat_wallpaper_model.dart';
import 'package:mio_amore/providers/chat_wallpaper_provider.dart';

class ChatPageBackground extends ConsumerWidget {
  final Widget child;
  const ChatPageBackground({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final _chatWallpaperProvider = ref.watch(chatWallpaperProvider);

    final ChatWallpaperModel? _chatWallpaperModel =
        _chatWallpaperProvider.getWallpaper();

    return Container(
      decoration: _chatWallpaperModel == null
          ? const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppConfig.defaultChatBg),
                fit: BoxFit.cover,
              ),
            )
          : _chatWallpaperModel.imagePath != null
              ? BoxDecoration(
                  image: DecorationImage(
                    image: FileImage(File(_chatWallpaperModel.imagePath!)),
                    fit: BoxFit.cover,
                    onError: (_, __) =>
                        const AssetImage(AppConfig.defaultChatBg),
                  ),
                )
              : _chatWallpaperModel.solidColor != null
                  ? BoxDecoration(
                      color: _chatWallpaperModel.solidColor,
                    )
                  : const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(AppConfig.defaultChatBg),
                        fit: BoxFit.cover,
                      ),
                    ),
      child: child,
    );
  }
}

class ChatWallpaperPage extends ConsumerWidget {
  const ChatWallpaperPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat Background"),
      ),
      body: GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.0,
          crossAxisSpacing: AppConstants.defaultNumericValue,
          mainAxisSpacing: AppConstants.defaultNumericValue,
        ),
        padding: const EdgeInsets.all(AppConstants.defaultNumericValue),
        children: [
          GestureDetector(
            onTap: () {
              // ref
              //     .read(chatWallpaperProvider)
              //     .setWallpaper(ChatWallpaperModel(solidColor: Colors.green));

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) {
                        return const ChatWallpaperSolidColors();
                      },
                      fullscreenDialog: true));
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                      AppConstants.defaultNumericValue / 2),
                  border: Border.all(
                      color: AppConfig.primaryColor.withOpacity(0.5), width: 2),
                  color: AppConfig.primaryColor.withOpacity(0.3)),
              child: const Center(child: Text("Solid Color")),
            ),
          ),
          //My Photos
          GestureDetector(
            onTap: () async {
              final _path = await pickMedia();
              if (_path != null) {
                await ref.read(chatWallpaperProvider).setWallpaper(
                      ChatWallpaperModel(imagePath: _path),
                    );
                Navigator.pop(context);
              }
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(AppConstants.defaultNumericValue / 2),
                border: Border.all(
                    color: AppConfig.primaryColor.withOpacity(0.5), width: 2),
                color: Colors.white,
              ),
              child: const Center(child: Text("My Photos")),
            ),
          ),
          GestureDetector(
            onTap: () {
              ref.read(chatWallpaperProvider).setWallpaper(null);
              Navigator.pop(context);
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                      AppConstants.defaultNumericValue / 2),
                  border: Border.all(
                      color: AppConfig.primaryColor.withOpacity(0.5), width: 2),
                  image: const DecorationImage(
                      image: AssetImage(AppConfig.defaultChatBg),
                      fit: BoxFit.cover)),
              child: const Center(child: Text("Default")),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatWallpaperSolidColors extends ConsumerWidget {
  const ChatWallpaperSolidColors({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Solid Colors"),
      ),
      body: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.6,
            crossAxisSpacing: AppConstants.defaultNumericValue / 2,
            mainAxisSpacing: AppConstants.defaultNumericValue / 2,
          ),
          padding: const EdgeInsets.all(AppConstants.defaultNumericValue / 2),
          // children: [

          // ],
          children: AppConfig.wallpaperSolidColors.map((e) {
            return GestureDetector(
              onTap: () async {
                await ref
                    .read(chatWallpaperProvider)
                    .setWallpaper(ChatWallpaperModel(solidColor: e));
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        AppConstants.defaultNumericValue / 2),
                    color: e),
              ),
            );
          }).toList()),
    );
  }
}
