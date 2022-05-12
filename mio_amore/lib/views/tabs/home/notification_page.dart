import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mio_amore/models/match_model.dart';
import 'package:mio_amore/providers/match_provider.dart';
import 'package:swipe_cards/swipe_cards.dart';

import 'package:mio_amore/helpers/constants.dart';
import 'package:mio_amore/models/user_interaction_model.dart';
import 'package:mio_amore/models/user_profile_model.dart';
import 'package:mio_amore/providers/interaction_provider.dart';
import 'package:mio_amore/providers/other_users_provider.dart';
import 'package:mio_amore/providers/user_profile_provider.dart';
import 'package:mio_amore/views/custom/custom_app_bar.dart';
import 'package:mio_amore/views/custom/custom_icon_button.dart';
import 'package:mio_amore/views/others/user_card_widget.dart';
import 'package:mio_amore/views/settings/account_settings.dart';
import 'package:mio_amore/views/tabs/home/app_drawer.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        leading: const SizedBox(),
        toolbarHeight: 0,
        // actions: [

        // ],
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.defaultNumericValue),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppConstants.defaultNumericValue),
            CustomAppBar(
              leading: CustomIconButton(
                icon: CupertinoIcons.square_grid_2x2_fill,
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
                padding: const EdgeInsets.all(
                    AppConstants.defaultNumericValue / 1.5),
              ),
              title: Consumer(builder: (context, ref, _) {
                final _user = ref.watch(userProfileStreamProvider);
                return _user.when(
                    data: (data) {
                      return data == null
                          ? const SizedBox()
                          : GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const AccountSettingsLandingWidget(),
                                  ),
                                );
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    CupertinoIcons.location_solid,
                                    color: AppConstants.primaryColor,
                                    size: 18,
                                  ),
                                  const SizedBox(
                                      width:
                                          AppConstants.defaultNumericValue / 3),
                                  Flexible(
                                    child: Text(
                                      data.userAccountSettingsModel.location
                                          .addressText,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2!
                                          .copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  // const SizedBox(
                                  //     width:
                                  //         AppConstants.defaultNumericValue / 3),
                                  // Icon(
                                  //   Icons.keyboard_arrow_down,
                                  //   color: AppConstants.primaryColor,
                                  // ),
                                ],
                              ),
                            );
                    },
                    error: (_, __) => const SizedBox(),
                    loading: () => const SizedBox());
              }),
              trailing: CustomIconButton(
                icon: CupertinoIcons.bell_solid,
                onPressed: () {
                  //TODO: Open Notifications!!
                },
                padding: const EdgeInsets.all(
                    AppConstants.defaultNumericValue / 1.5),
              ),
            ),
            Expanded(
              child: Consumer(
                builder: (context, ref, child) {
                  final _filteredUsers = ref.watch(filteredOtherUsersProvider);

                  return _filteredUsers.when(
                    data: (data) {
                      return data.isEmpty
                          ? const SizedBox()
                          : FilterInteraction(users: data);
                    },
                    error: (_, __) => const Center(
                      child: Text("Something Went Wrong!"),
                    ),
                    loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FilterInteraction extends ConsumerWidget {
  final List<UserProfileModel> users;
  const FilterInteraction({
    Key? key,
    required this.users,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _interactionFutureProvider = ref.watch(interactionFutureProvider);

    return _interactionFutureProvider.when(
      data: (data) {
        final List<UserProfileModel> _filteredUsers = [];

        for (final user in users) {
          if (!data.any(
              (element) => element.intractToUserId.contains(user.userId))) {
            _filteredUsers.add(user);
          }
        }

        return _filteredUsers.isEmpty
            ? const Center(child: Text("No User Found!"))
            : HomeBody(users: _filteredUsers);
      },
      error: (_, __) => const Center(
        child: Text("Something Went Wrong!"),
      ),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class HomeBody extends ConsumerStatefulWidget {
  final List<UserProfileModel> users;

  const HomeBody({
    Key? key,
    required this.users,
  }) : super(key: key);

  @override
  ConsumerState<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends ConsumerState<HomeBody> {
  late MatchEngine _matchEngine;
  final List<SwipeItem> _swipeItems = [];

  @override
  void initState() {
    final _users = widget.users;
    _users.shuffle();

    for (var user in widget.users) {
      _swipeItems.add(
        SwipeItem(
          content: user,
          likeAction: () {
            print("Swapping!! Like");
          },
          nopeAction: () {
            print("Swapping!! Nope");
          },
          superlikeAction: () {
            print("Swapping!! Superlike");
          },
        ),
      );
    }

    _matchEngine = MatchEngine(swipeItems: _swipeItems);

    super.initState();
  }

  @override
  void dispose() {
    _matchEngine.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        width: MediaQuery.of(context).size.width * 0.8,
        child: SwipeCards(
          upSwipeAllowed: true,
          matchEngine: _matchEngine,
          onStackFinished: () {
            ref.refresh(interactionFutureProvider);
          },
          itemBuilder: (context, index) {
            final _user = _swipeItems[index].content as UserProfileModel;

            final _interactionProvider = ref.read(interactionProvider);

            final String _myUserId = FirebaseAuth.instance.currentUser!.uid;
            final String _id = _myUserId + _user.id;

            final UserInteractionModel _interaction = UserInteractionModel(
              id: _id,
              userId: _myUserId,
              intractToUserId: _user.id,
              isSuperLike: false,
              isLike: false,
              isDislike: false,
              createdAt: DateTime.now(),
            );

            return UserCardWidget(
              user: _swipeItems[index].content,
              onTapBolt: () async {
                _matchEngine.currentItem?.superLike();
                final _newInteraction = _interaction.copyWith(
                    isSuperLike: true, createdAt: DateTime.now());
                final _result = await _interactionProvider
                    .createInteraction(_newInteraction);

                if (_result) {
                  final UserInteractionModel? _otherUserInteraction =
                      await _interactionProvider
                          .getExistingInteraction(_user.id);
                  if (_otherUserInteraction != null) {
                    showMatchingDialog(
                        context, ref, _otherUserInteraction.userId);
                  }
                }
              },
              onTapCross: () async {
                _matchEngine.currentItem?.nope();
                final _newInteraction = _interaction.copyWith(
                    isDislike: true, createdAt: DateTime.now());
                await _interactionProvider.createInteraction(_newInteraction);
              },
              onTapHeart: () async {
                _matchEngine.currentItem?.like();
                final _newInteraction = _interaction.copyWith(
                    isLike: true, createdAt: DateTime.now());
                final _result = await _interactionProvider
                    .createInteraction(_newInteraction);

                if (_result) {
                  final UserInteractionModel? _otherUserInteraction =
                      await _interactionProvider
                          .getExistingInteraction(_user.id);
                  if (_otherUserInteraction != null) {
                    showMatchingDialog(
                        context, ref, _otherUserInteraction.userId);
                  }
                }
              },
            );
          },
        ),
      ),
    );
  }
}

class UserCirlePicture extends StatelessWidget {
  final String? imageUrl;
  final double? size;
  const UserCirlePicture({
    Key? key,
    required this.imageUrl,
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _size = size ?? AppConstants.defaultNumericValue * 5;
    return Container(
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(AppConstants.defaultNumericValue * 10),
        border: Border.all(color: AppConstants.primaryColor, width: 2),
      ),
      child: ClipRRect(
        borderRadius:
            BorderRadius.circular(AppConstants.defaultNumericValue * 10),
        child: SizedBox(
          width: _size,
          height: _size,
          child: imageUrl == null || imageUrl!.isEmpty
              ? CircleAvatar(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  child: Icon(
                    CupertinoIcons.person_fill,
                    color: AppConstants.primaryColor,
                    size: _size * 0.8,
                  ),
                )
              : CachedNetworkImage(
                  imageUrl: imageUrl!,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) =>
                      const Center(child: Icon(Icons.error)),
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }
}

Future<void> showMatchingDialog(
    BuildContext context, WidgetRef ref, String otherUserId) async {
  final _filteredUsers = ref.watch(filteredOtherUsersProvider);
  final _userProfile = ref.watch(userProfileStreamProvider);
  final _mathcProvider = ref.read(matchProvider);

  UserProfileModel? _otherUserProfile;
  UserProfileModel? _currentUserProfile;

  _filteredUsers.whenData((value) {
    _otherUserProfile =
        value.firstWhere((element) => element.userId == otherUserId);
  });

  _userProfile.whenData((value) {
    _currentUserProfile = value;
  });

  if (_otherUserProfile != null && _currentUserProfile != null) {
    final MatchModel _matchModel = MatchModel(
      id: _currentUserProfile!.userId + _otherUserProfile!.userId,
      userIds: [_currentUserProfile!.userId, _otherUserProfile!.userId],
    );

    final _matchResult = await _mathcProvider.createConversation(_matchModel);

    if (_matchResult) {
      return await showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(AppConstants.defaultNumericValue),
            ),
            insetPadding:
                const EdgeInsets.all(AppConstants.defaultNumericValue * 2),
            contentPadding:
                const EdgeInsets.all(AppConstants.defaultNumericValue * 2),
            title: const Center(child: Text("Matched")),
            children: [
              const SizedBox(height: AppConstants.defaultNumericValue),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  UserCirlePicture(imageUrl: _otherUserProfile?.profilePicture),
                  const SizedBox(width: AppConstants.defaultNumericValue / 4),
                  UserCirlePicture(
                      imageUrl: _currentUserProfile?.profilePicture),
                ],
              ),
              const SizedBox(height: AppConstants.defaultNumericValue),
              Center(
                child: Text(
                    "You are now matched with ${_otherUserProfile!.fullName}"),
              ),
              const SizedBox(height: AppConstants.defaultNumericValue),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("Not Now"))),
                  const SizedBox(width: AppConstants.defaultNumericValue),
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          //TODO: Open Chat Screen
                        },
                        child: const Text("Start Chat")),
                  ),
                ],
              ),
            ],
          );
        },
      );
    }
  }
}
