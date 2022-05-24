import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mio_amore/models/chat_item_model.dart';
import 'package:mio_amore/providers/chat_provider.dart';
import 'package:mio_amore/views/others/error_page.dart';
import 'package:mio_amore/views/others/loading_page.dart';
import 'package:mio_amore/views/others/photo_view_page.dart';
import 'package:mio_amore/views/others/video_player_page.dart';

class ChatMediaGalleryConsumerPage extends ConsumerWidget {
  final String matchId;
  const ChatMediaGalleryConsumerPage({
    Key? key,
    required this.matchId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _chatStreams = ref.watch(chatStreamProviderProvider(matchId));

    return _chatStreams.when(
        data: (data) {
          final List<ChatItemModel> _chatsWithImagesOrVideos = [];
          for (var chat in data) {
            if (chat.image != null || chat.video != null) {
              _chatsWithImagesOrVideos.add(chat);
            }
          }
          return ChatMediaGalleryPage(chats: _chatsWithImagesOrVideos);
        },
        error: (_, __) => const ErrorPage(),
        loading: () => const LoadingPage());
  }
}

class ChatMediaGalleryPage extends StatefulWidget {
  final List<ChatItemModel> chats;
  const ChatMediaGalleryPage({
    Key? key,
    required this.chats,
  }) : super(key: key);

  @override
  State<ChatMediaGalleryPage> createState() => _ChatMediaGalleryPageState();
}

class _ChatMediaGalleryPageState extends State<ChatMediaGalleryPage> {
  @override
  Widget build(BuildContext context) {
    widget.chats.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    List<ChatItemModel> _chatsWithImages =
        widget.chats.where((chat) => chat.image != null).toList();
    List<ChatItemModel> _chatsWithVideos =
        widget.chats.where((chat) => chat.video != null).toList();

    //Tab View with images and videos
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Media Gallery'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Images'),
              Tab(text: 'Videos'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _chatsWithImages.isEmpty
                ? const Center(child: Text('No images'))
                : GridView.builder(
                    itemCount: _chatsWithImages.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PhotoViewPage(
                                      images: _chatsWithImages
                                          .map((e) => e.image!)
                                          .toList(),
                                      index: index,
                                    )),
                          );
                        },
                        child: CachedNetworkImage(
                            imageUrl: _chatsWithImages[index].image!),
                      );
                    },
                  ),
            _chatsWithVideos.isEmpty
                ? const Center(child: Text('No videos'))
                : GridView.builder(
                    itemCount: _chatsWithVideos.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 1),
                        ),
                        child: VideoPlayerThumbNail(onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VideoPlayerPage(
                                  videoUrl: _chatsWithVideos[index].video!,
                                  isNetwork: true),
                            ),
                          );
                        }),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
