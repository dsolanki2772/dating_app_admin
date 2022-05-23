import 'dart:io';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mio_amore/config/config.dart';
import 'package:mio_amore/helpers/constants.dart';
import 'package:mio_amore/helpers/date_formater.dart';
import 'package:mio_amore/models/chat_item_model.dart';
import 'package:mio_amore/models/user_profile_model.dart';
import 'package:mio_amore/providers/chat_provider.dart';
import 'package:mio_amore/views/others/user_details_page.dart';
import 'package:mio_amore/views/tabs/home/notification_page.dart';
import 'package:mio_amore/views/tabs/messages/components/chat_page_background.dart';

class ChatPage extends ConsumerStatefulWidget {
  final UserProfileModel otherUser;
  final String matchId;
  const ChatPage({
    Key? key,
    required this.otherUser,
    required this.matchId,
  }) : super(key: key);

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final _chatController = TextEditingController();
  bool emojiShowing = false;

  void _onSendMessage() async {
    final _chatProvider = ref.read(chatProvider);

    if (_chatController.text.isNotEmpty) {
      final _currentTime = DateTime.now();
      ChatItemModel chatItem = ChatItemModel(
        message: _chatController.text,
        createdAt: _currentTime,
        id: _currentTime.millisecondsSinceEpoch.toString(),
        userId: FirebaseAuth.instance.currentUser!.uid,
        matchId: widget.matchId,
      );
      await _chatProvider.createChatItem(widget.matchId, chatItem);
      _chatController.clear();
    }
  }

  _onEmojiSelected(Emoji emoji) {
    setState(() {
      _chatController
        ..text += emoji.emoji
        ..selection = TextSelection.fromPosition(
            TextPosition(offset: _chatController.text.length));
    });
  }

  _onBackspacePressed() {
    setState(() {
      _chatController
        ..text = _chatController.text.characters.skipLast(1).toString()
        ..selection = TextSelection.fromPosition(
            TextPosition(offset: _chatController.text.length));
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        setState(() {
          emojiShowing = false;
        });
      },
      child: ChatPageBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            toolbarHeight: 0,
            backgroundColor: AppConstants.primaryColor.withOpacity(0.8),
            elevation: 0,
            systemOverlayStyle: SystemUiOverlayStyle.light,
          ),
          body: SafeArea(
            top: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ChatTopBar(
                  otherUser: widget.otherUser,
                  matchId: widget.matchId,
                ),
                Expanded(
                  child: ChatBody(matchId: widget.matchId),
                ),
                const SizedBox(height: AppConstants.defaultNumericValue / 2),
                ChatTextFieldAndOthers(
                  chatController: _chatController,
                  onChangeText: () {
                    setState(() {});
                  },
                  onTapEmoji: () {
                    setState(() {
                      emojiShowing = !emojiShowing;
                    });
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  onTapVoice: () {},
                  onTapTextField: () {
                    setState(() {
                      emojiShowing = false;
                    });
                  },
                  onTapSend: _onSendMessage,
                ),
                const SizedBox(height: AppConstants.defaultNumericValue / 2),
                Offstage(
                  offstage: !emojiShowing,
                  child: SizedBox(
                    height: 250,
                    child: EmojiPicker(
                      onEmojiSelected: (Category category, Emoji emoji) {
                        _onEmojiSelected(emoji);
                      },
                      onBackspacePressed: _onBackspacePressed,
                      config: _emojiPickerConfig,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChatBody extends ConsumerWidget {
  final String matchId;
  const ChatBody({
    Key? key,
    required this.matchId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final _chatStreams = ref.watch(chatStreamProviderProvider(matchId));

    return _chatStreams.when(
        data: (data) {
          return ListView(
            reverse: true,
            children: data.map((e) {
              final bool? _isNotMe = e.userId == null
                  ? null
                  : e.userId != FirebaseAuth.instance.currentUser?.uid;

              return _isNotMe == null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                          child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.defaultNumericValue,
                          vertical: AppConstants.defaultNumericValue / 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(
                            AppConstants.defaultNumericValue,
                          ),
                        ),
                        child: Text(e.message ?? ""),
                      )),
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Align(
                          alignment: _isNotMe
                              ? Alignment.centerLeft
                              : Alignment.centerRight,
                          child: Container(
                            margin: const EdgeInsets.all(
                                AppConstants.defaultNumericValue / 4),
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.8,
                            ),
                            decoration: BoxDecoration(
                              color: _isNotMe
                                  ? AppConfig.chatTextFieldAndOtherText
                                  : AppConfig.chatMyTextColor,
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(
                                    AppConstants.defaultNumericValue),
                                topRight: const Radius.circular(
                                    AppConstants.defaultNumericValue),
                                bottomLeft: _isNotMe
                                    ? Radius.zero
                                    : const Radius.circular(
                                        AppConstants.defaultNumericValue),
                                bottomRight: _isNotMe
                                    ? const Radius.circular(
                                        AppConstants.defaultNumericValue)
                                    : Radius.zero,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(
                                  AppConstants.defaultNumericValue / 1.3),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    e.message ?? "",
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    DateFormatter.toWholeDateTime(e.createdAt),
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        _isNotMe
                            ? const SizedBox(
                                height: AppConstants.defaultNumericValue / 8)
                            : const SizedBox()
                      ],
                    );
            }).toList(),
          );
        },
        error: (_, __) => const SizedBox(),
        loading: () => const SizedBox());
    // return ListView(
    //   reverse: true,
    //   shrinkWrap: true,
    //   children: [
    //     for (var i = 0; i < 100; i++)

    //   ],
    // );
  }
}

class ChatTopBar extends ConsumerStatefulWidget {
  final UserProfileModel otherUser;
  final String matchId;
  const ChatTopBar({
    Key? key,
    required this.otherUser,
    required this.matchId,
  }) : super(key: key);

  @override
  ConsumerState<ChatTopBar> createState() => _ChatTopBarState();
}

class _ChatTopBarState extends ConsumerState<ChatTopBar> {
  final CustomPopupMenuController _moreMenuController =
      CustomPopupMenuController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(AppConstants.defaultNumericValue),
            bottomRight: Radius.circular(AppConstants.defaultNumericValue),
          ),
          gradient: AppConstants.defaultGradient),
      child: ListTile(
        onTap: () {
          Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) => UserDetailsPage(
                user: widget.otherUser,
                matchId: widget.matchId,
              ),
            ),
          );
        },
        contentPadding: const EdgeInsets.only(bottom: 4),
        title: Text(
          widget.otherUser.fullName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
        ),
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const BackButton(color: Colors.white),
            UserCirlePicture(
              imageUrl: widget.otherUser.profilePicture,
              size: AppConstants.defaultNumericValue * 3,
            )
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              child:
                  const Icon(CupertinoIcons.phone_solid, color: Colors.white),
              onPressed: () {},
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Icon(CupertinoIcons.video_camera_solid,
                  color: Colors.white),
              onPressed: () {},
            ),
            CustomPopupMenu(
              child: const CupertinoButton(
                padding: EdgeInsets.zero,
                child:
                    Icon(CupertinoIcons.ellipsis_vertical, color: Colors.white),
                onPressed: null,
              ),
              menuBuilder: () => ClipRRect(
                borderRadius:
                    BorderRadius.circular(AppConstants.defaultNumericValue / 2),
                child: Container(
                  decoration: const BoxDecoration(color: Colors.white),
                  child: IntrinsicWidth(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        MoreMenuTitle(
                          title: 'View Profile',
                          onTap: () {
                            _moreMenuController.hideMenu();
                            Navigator.of(context).push(
                              CupertinoPageRoute(
                                builder: (context) => UserDetailsPage(
                                  user: widget.otherUser,
                                  matchId: widget.matchId,
                                ),
                              ),
                            );
                          },
                        ),
                        MoreMenuTitle(
                          title: 'Media Gallery',
                          onTap: () {
                            _moreMenuController.hideMenu();
                          },
                        ),
                        MoreMenuTitle(
                          title: 'Search',
                          onTap: () {
                            _moreMenuController.hideMenu();
                          },
                        ),
                        MoreMenuTitle(
                          title: 'Background',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ChatWallpaperPage()),
                            );
                            _moreMenuController.hideMenu();
                          },
                        ),
                        MoreMenuTitle(
                          title: 'Clear Chat',
                          onTap: () async {
                            _moreMenuController.hideMenu();
                            await ref
                                .read(chatProvider)
                                .clearChat(widget.matchId)
                                .then((value) {
                              if (value) {
                                Navigator.of(context).pop();
                              }
                            });
                          },
                        ),
                        MoreMenuTitle(
                          title: 'Report',
                          onTap: () {
                            _moreMenuController.hideMenu();
                          },
                        ),
                        MoreMenuTitle(
                          title: 'Block',
                          onTap: () {
                            _moreMenuController.hideMenu();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              pressType: PressType.singleClick,
              verticalMargin: 0,
              controller: _moreMenuController,
              showArrow: true,
              arrowColor: Colors.white,
              barrierColor: AppConstants.primaryColor.withOpacity(0.1),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatTextFieldAndOthers extends StatefulWidget {
  final TextEditingController chatController;
  final VoidCallback onTapEmoji;
  final VoidCallback onTapVoice;
  final VoidCallback onTapSend;
  final VoidCallback onChangeText;
  final VoidCallback onTapTextField;
  const ChatTextFieldAndOthers({
    Key? key,
    required this.chatController,
    required this.onTapEmoji,
    required this.onTapVoice,
    required this.onTapSend,
    required this.onChangeText,
    required this.onTapTextField,
  }) : super(key: key);

  @override
  State<ChatTextFieldAndOthers> createState() => _ChatTextFieldAndOthersState();
}

class _ChatTextFieldAndOthersState extends State<ChatTextFieldAndOthers> {
  final CustomPopupMenuController _addMenuController =
      CustomPopupMenuController();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CustomPopupMenu(
          child: CupertinoButton(
            padding: EdgeInsets.zero,
            child: Icon(CupertinoIcons.add_circled_solid,
                color: AppConstants.primaryColor),
            onPressed: null,
          ),
          menuBuilder: () => ClipRRect(
            borderRadius:
                BorderRadius.circular(AppConstants.defaultNumericValue / 2),
            child: Container(
              decoration: BoxDecoration(color: AppConstants.primaryColor),
              child: IntrinsicWidth(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ChatAddMenuItem(
                      icon: CupertinoIcons.photo_camera_solid,
                      title: 'Camera',
                      onTap: () {
                        _addMenuController.hideMenu();
                      },
                    ),
                    ChatAddMenuItem(
                      icon: CupertinoIcons.photo_fill,
                      title: 'Gallery',
                      onTap: () {
                        _addMenuController.hideMenu();
                      },
                    ),
                    ChatAddMenuItem(
                      icon: CupertinoIcons.mic_solid,
                      title: 'Audio',
                      onTap: () {
                        _addMenuController.hideMenu();
                      },
                    ),
                    ChatAddMenuItem(
                      icon: CupertinoIcons.video_camera_solid,
                      title: 'Video',
                      onTap: () {
                        _addMenuController.hideMenu();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          pressType: PressType.singleClick,
          verticalMargin: -10,
          controller: _addMenuController,
          arrowColor: AppConstants.primaryColor,
          barrierColor: AppConstants.primaryColor.withOpacity(0.1),
        ),
        Expanded(
          child: Container(
            padding:
                const EdgeInsets.only(left: AppConstants.defaultNumericValue),
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(AppConstants.defaultNumericValue),
              color: AppConfig.chatTextFieldAndOtherText,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: widget.chatController,
                    keyboardType: TextInputType.text,
                    minLines: null,
                    onTap: widget.onTapTextField,
                    onSubmitted: (value) {
                      widget.onTapSend();
                    },
                    onChanged: (_) {
                      widget.onChangeText();
                    },
                    decoration: const InputDecoration(
                      hintText: 'Type here...',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                    ),
                  ),
                ),
                //Emoji
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: const Icon(CupertinoIcons.smiley),
                  onPressed: widget.onTapEmoji,
                ),
              ],
            ),
          ),
        ),
        widget.chatController.text.isEmpty
            ? CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Icon(CupertinoIcons.mic_circle_fill),
                onPressed: widget.onTapVoice,
              )
            : CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Icon(CupertinoIcons.paperplane_fill),
                onPressed: widget.onTapSend,
              ),
      ],
    );
  }
}

class MoreMenuTitle extends StatelessWidget {
  final VoidCallback onTap;

  final String title;
  const MoreMenuTitle({
    Key? key,
    required this.onTap,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.defaultNumericValue,
            vertical: AppConstants.defaultNumericValue / 1.2),
        child: Text(title,
            style: Theme.of(context)
                .textTheme
                .subtitle2!
                .copyWith(color: Colors.black87)),
      ),
    );
  }
}

class ChatAddMenuItem extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final String title;
  const ChatAddMenuItem({
    Key? key,
    required this.onTap,
    required this.icon,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.defaultNumericValue,
            vertical: AppConstants.defaultNumericValue / 1.2),
        child: Row(
          children: [
            Icon(
              icon,
              size: Theme.of(context).textTheme.subtitle2!.fontSize,
              color: Colors.white,
            ),
            const SizedBox(width: AppConstants.defaultNumericValue),
            Expanded(
              child: Text(title,
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

final _emojiPickerConfig = Config(
  columns: 7,
  emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
  verticalSpacing: 0,
  horizontalSpacing: 0,
  initCategory: Category.RECENT,
  bgColor: Colors.black.withOpacity(0.05),
  indicatorColor: AppConstants.primaryColor,
  iconColor: Colors.grey,
  iconColorSelected: AppConstants.primaryColor,
  progressIndicatorColor: AppConstants.primaryColor,
  backspaceColor: AppConstants.primaryColor,
  skinToneDialogBgColor: Colors.white,
  skinToneIndicatorColor: Colors.grey,
  enableSkinTones: true,
  showRecentsTab: true,
  recentsLimit: 40,
  categoryIcons: const CategoryIcons(),
  buttonMode: ButtonMode.CUPERTINO,
);
