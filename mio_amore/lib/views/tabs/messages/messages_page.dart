import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mio_amore/helpers/constants.dart';
import 'package:mio_amore/models/match_model.dart';
import 'package:mio_amore/models/user_profile_model.dart';
import 'package:mio_amore/providers/match_provider.dart';
import 'package:mio_amore/providers/other_users_provider.dart';
import 'package:mio_amore/views/custom/custom_app_bar.dart';
import 'package:mio_amore/views/custom/custom_headline.dart';
import 'package:mio_amore/views/custom/custom_icon_button.dart';
import 'package:mio_amore/views/others/error_page.dart';
import 'package:mio_amore/views/others/loading_page.dart';
import 'package:mio_amore/views/tabs/home/home_page.dart';
import 'package:mio_amore/views/tabs/messages/components/chat_page.dart';

class MessagesPage extends ConsumerStatefulWidget {
  const MessagesPage({Key? key}) : super(key: key);

  @override
  ConsumerState<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends ConsumerState<MessagesPage> {
  bool _isSearchBarVisible = false;
  final _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final _matchStreamProvider = ref.watch(matchStreamProvider);

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
                // SizedBox(
                //   height: AppConstants.defaultNumericValue * 4,
                //   child: ListView(
                //     scrollDirection: Axis.horizontal,
                //     shrinkWrap: true,
                //     children: [
                //       for (var i = 0; i < 30; i++)
                //         Stack(
                //           children: [
                //             Container(
                //               width: AppConstants.defaultNumericValue * 4,
                //               margin: EdgeInsets.only(
                //                 right: AppConstants.defaultNumericValue / 2,
                //                 left: i == 0
                //                     ? AppConstants.defaultNumericValue
                //                     : 0,
                //               ),
                //               decoration: BoxDecoration(
                //                 borderRadius: BorderRadius.circular(
                //                     AppConstants.defaultNumericValue * 4),
                //                 border: Border.all(
                //                   color: AppConstants.primaryColor
                //                       .withOpacity(0.4),
                //                   width: 1.5,
                //                 ),
                //               ),
                //               child: ClipRRect(
                //                 borderRadius: BorderRadius.circular(
                //                     AppConstants.defaultNumericValue * 10),
                //                 child: CachedNetworkImage(
                //                   imageUrl: defaultImage,
                //                   fit: BoxFit.cover,
                //                 ),
                //               ),
                //             ),
                //             Positioned(
                //               bottom: AppConstants.defaultNumericValue / 4,
                //               right: AppConstants.defaultNumericValue / 2,
                //               child: Badge(
                //                 badgeColor: AppConstants.primaryColor,
                //                 elevation: 0,
                //                 animationType: BadgeAnimationType.scale,
                //                 borderSide: const BorderSide(
                //                     color: Colors.white70, width: 1.5),
                //                 padding: const EdgeInsets.all(
                //                     AppConstants.defaultNumericValue / 2.5),
                //               ),
                //             )
                //           ],
                //         ),
                //     ],
                //   ),
                // ),
                // const SizedBox(height: AppConstants.defaultNumericValue),
                // Padding(
                //   padding: const EdgeInsets.symmetric(
                //       horizontal: AppConstants.defaultNumericValue),
                //   child: Text(
                //     "Messages",
                //     style: Theme.of(context)
                //         .textTheme
                //         .headline6!
                //         .copyWith(fontWeight: FontWeight.bold),
                //   ),
                // ),
                // const SizedBox(height: AppConstants.defaultNumericValue),
                Expanded(
                    child: _matchStreamProvider.when(
                        data: (data) {
                          final _otherUserIds = data
                              .map((e) => e.userIds.firstWhere((element) =>
                                  element !=
                                  FirebaseAuth.instance.currentUser!.uid))
                              .toList();

                          final _otherUsersProvider =
                              ref.watch(otherUsersProvider);
                          List<UserProfileModel> _matchedUsers = [];
                          _otherUsersProvider.whenData((value) {
                            _matchedUsers = value.where((element) {
                              return _otherUserIds.contains(element.userId);
                            }).toList();
                          });

                          final _searchedUsers = _matchedUsers.where((element) {
                            return element.fullName
                                .toLowerCase()
                                .contains(_searchController.text.toLowerCase());
                          }).toList();

                          return _searchedUsers.isEmpty
                              ? Center(child: Text('No messages found'))
                              : ListView.builder(
                                  itemCount: _searchedUsers.length,
                                  itemBuilder: (context, index) {
                                    final _user = _searchedUsers[index];
                                    return ConversationTile(user: _user);
                                  },
                                );
                        },
                        error: (_, __) => const ErrorPage(),
                        loading: () => const LoadingPage())),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ConversationTile extends ConsumerWidget {
  final UserProfileModel user;
  const ConversationTile({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => const ChatPage()),
            );
          },
          title: Row(
            children: [
              Expanded(
                child: Text(
                  user.fullName,
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              const SizedBox(width: AppConstants.defaultNumericValue),
              Text(
                "12:00 PM",
                style: Theme.of(context).textTheme.subtitle1!,
              ),
            ],
          ),
          subtitle: const Text(
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          leading: UserCirlePicture(
              imageUrl: user.profilePicture,
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
