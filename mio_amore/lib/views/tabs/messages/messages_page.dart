import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mio_amore/helpers/constants.dart';
import 'package:mio_amore/helpers/date_formater.dart';
import 'package:mio_amore/helpers/encrypt_helper.dart';
import 'package:mio_amore/models/chat_item_model.dart';
import 'package:mio_amore/models/user_profile_model.dart';
import 'package:mio_amore/providers/chat_provider.dart';
import 'package:mio_amore/providers/match_provider.dart';
import 'package:mio_amore/providers/other_users_provider.dart';
import 'package:mio_amore/views/custom/custom_app_bar.dart';
import 'package:mio_amore/views/custom/custom_headline.dart';
import 'package:mio_amore/views/custom/custom_icon_button.dart';
import 'package:mio_amore/views/others/error_page.dart';
import 'package:mio_amore/views/others/loading_page.dart';
import 'package:mio_amore/views/tabs/home/home_page.dart';
import 'package:mio_amore/views/tabs/messages/components/chat_page.dart';

class MessageConsumerPage extends ConsumerWidget {
  const MessageConsumerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _matchStreamProvider = ref.watch(matchStreamProvider);

    return _matchStreamProvider.when(
        data: (data) {
          final _otherUserIds = data
              .map((e) => e.userIds.firstWhere((element) =>
                  element != FirebaseAuth.instance.currentUser!.uid))
              .toList();

          final _otherUsersProvider = ref.watch(otherUsersProvider);
          List<UserProfileModel> _matchedUsers = [];
          _otherUsersProvider.whenData((value) {
            _matchedUsers = value.where((element) {
              return _otherUserIds.contains(element.userId);
            }).toList();
          });

          List<MessageViewModel> _messages = [];

          for (var match in data) {
            final _chatProvider =
                ref.watch(chatStreamProviderProvider(match.id));
            _chatProvider.whenData((value) {
              final UserProfileModel _otherUser = _matchedUsers.firstWhere(
                  (element) =>
                      element.userId ==
                      match.userIds.firstWhere((element) =>
                          element != FirebaseAuth.instance.currentUser!.uid));

              if (value.isNotEmpty) {
                MessageViewModel _message = MessageViewModel(
                  matchedUser: _otherUser,
                  lastMessage: value.first,
                  lastMessageDate: value.first.createdAt,
                  matchId: match.id,
                );

                _messages.add(_message);
              }
            });
          }

          return MessagesPage(messages: _messages);
        },
        error: (_, __) => const ErrorPage(),
        loading: () => const LoadingPage());
  }
}

class MessagesPage extends ConsumerStatefulWidget {
  final List<MessageViewModel> messages;
  const MessagesPage({
    Key? key,
    required this.messages,
  }) : super(key: key);

  @override
  ConsumerState<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends ConsumerState<MessagesPage> {
  bool _isSearchBarVisible = false;
  final _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final _searchedMessages = widget.messages.where((element) {
      return element.matchedUser.fullName
          .toLowerCase()
          .contains(_searchController.text.toLowerCase());
    }).toList();

    _searchedMessages.sort((a, b) {
      return b.lastMessageDate.compareTo(a.lastMessageDate);
    });

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppConstants.defaultNumericValue),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.defaultNumericValue),
            child: CustomAppBar(
              leading: CustomIconButton(
                icon: CupertinoIcons.search,
                onPressed: () {
                  setState(() {
                    _isSearchBarVisible = !_isSearchBarVisible;
                  });
                },
                padding: const EdgeInsets.all(
                    AppConstants.defaultNumericValue / 1.5),
              ),
              title: Center(
                child: CustomHeadLine(
                  text: 'Messages',
                  secondPartColor: AppConstants.primaryColor,
                ),
              ),
              trailing: CustomIconButton(
                icon: CupertinoIcons.bell_solid,
                onPressed: () {
                  //TODO: Open Notifications!!
                },
                padding: const EdgeInsets.all(
                    AppConstants.defaultNumericValue / 1.5),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppConstants.defaultNumericValue),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.defaultNumericValue),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return SizeTransition(
                          sizeFactor: animation, child: child);
                    },
                    child: _isSearchBarVisible
                        ? Container(
                            key: const Key('searchBar'),
                            padding: const EdgeInsets.all(
                                AppConstants.defaultNumericValue / 3),
                            decoration: BoxDecoration(
                              color: AppConstants.primaryColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(
                                AppConstants.defaultNumericValue,
                              ),
                            ),
                            child: TextField(
                              controller: _searchController,
                              autofocus: true,
                              onChanged: (_) {
                                setState(() {});
                              },
                              decoration: InputDecoration(
                                hintText: 'Search here...',
                                border: InputBorder.none,
                                prefixIcon: Icon(
                                  CupertinoIcons.search,
                                  color: AppConstants.primaryColor,
                                ),
                              ),
                            ),
                          )
                        : const SizedBox(key: Key('noSearchBar')),
                  ),
                ),
                _isSearchBarVisible
                    ? const SizedBox(height: AppConstants.defaultNumericValue)
                    : const SizedBox(height: 0),
                Expanded(
                  child: _searchedMessages.isEmpty
                      ? const Center(child: Text('No messages found'))
                      : ListView.builder(
                          itemCount: _searchedMessages.length,
                          itemBuilder: (context, index) {
                            final _message = _searchedMessages[index];
                            return ConversationTile(messageViewModel: _message);
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ConversationTile extends ConsumerWidget {
  final MessageViewModel messageViewModel;
  const ConversationTile({
    Key? key,
    required this.messageViewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => ChatPage(
                  otherUser: messageViewModel.matchedUser,
                  matchId: messageViewModel.matchId,
                ),
              ),
            );
          },
          title: Row(
            children: [
              Expanded(
                child: Text(
                  messageViewModel.matchedUser.fullName,
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              const SizedBox(width: AppConstants.defaultNumericValue),
              Text(
                DateFormatter.toWholeDateTime(messageViewModel.lastMessageDate),
                style: Theme.of(context).textTheme.caption!,
              ),
            ],
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (messageViewModel.lastMessage.userId ==
                  FirebaseAuth.instance.currentUser!.uid)
                const Text('You: '),
              if (messageViewModel.lastMessage.image != null)
                Icon(
                  Icons.image,
                  color: AppConstants.primaryColor,
                ),
              if (messageViewModel.lastMessage.image != null)
                const SizedBox(width: AppConstants.defaultNumericValue / 2),
              if (messageViewModel.lastMessage.video != null)
                Icon(
                  Icons.movie,
                  color: AppConstants.primaryColor,
                ),
              if (messageViewModel.lastMessage.video != null)
                const SizedBox(width: AppConstants.defaultNumericValue / 2),
              Text(
                decryptText(messageViewModel.lastMessage.message ?? ""),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          leading: UserCirlePicture(
              imageUrl: messageViewModel.matchedUser.profilePicture,
              size: AppConstants.defaultNumericValue * 3),
        ),
        const Divider(
          height: 0,
          indent: AppConstants.defaultNumericValue,
          endIndent: AppConstants.defaultNumericValue,
        ),
      ],
    );
  }
}

class MessageViewModel {
  UserProfileModel matchedUser;
  String matchId;
  ChatItemModel lastMessage;
  DateTime lastMessageDate;
  MessageViewModel({
    required this.matchedUser,
    required this.matchId,
    required this.lastMessage,
    required this.lastMessageDate,
  });

  MessageViewModel copyWith({
    UserProfileModel? matchedUser,
    String? matchId,
    ChatItemModel? lastMessage,
    DateTime? lastMessageDate,
  }) {
    return MessageViewModel(
      matchedUser: matchedUser ?? this.matchedUser,
      matchId: matchId ?? this.matchId,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageDate: lastMessageDate ?? this.lastMessageDate,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'matchedUser': matchedUser.toMap()});
    result.addAll({'matchId': matchId});
    result.addAll({'lastMessage': lastMessage.toMap()});
    result.addAll({'lastMessageDate': lastMessageDate.millisecondsSinceEpoch});

    return result;
  }

  factory MessageViewModel.fromMap(Map<String, dynamic> map) {
    return MessageViewModel(
      matchedUser: UserProfileModel.fromMap(map['matchedUser']),
      matchId: map['matchId'] ?? '',
      lastMessage: ChatItemModel.fromMap(map['lastMessage']),
      lastMessageDate:
          DateTime.fromMillisecondsSinceEpoch(map['lastMessageDate']),
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageViewModel.fromJson(String source) =>
      MessageViewModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MessageViewModel(matchedUser: $matchedUser, matchId: $matchId, lastMessage: $lastMessage, lastMessageDate: $lastMessageDate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MessageViewModel &&
        other.matchedUser == matchedUser &&
        other.matchId == matchId &&
        other.lastMessage == lastMessage &&
        other.lastMessageDate == lastMessageDate;
  }

  @override
  int get hashCode {
    return matchedUser.hashCode ^
        matchId.hashCode ^
        lastMessage.hashCode ^
        lastMessageDate.hashCode;
  }
}
