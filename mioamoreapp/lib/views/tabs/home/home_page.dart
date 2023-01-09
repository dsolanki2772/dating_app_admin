import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mioamoreapp/models/match_model.dart';
import 'package:mioamoreapp/models/notification_model.dart';
import 'package:mioamoreapp/providers/auth_providers.dart';
import 'package:mioamoreapp/providers/match_provider.dart';
import 'package:mioamoreapp/providers/notifiaction_provider.dart';
import 'package:mioamoreapp/views/tabs/home/notification_page.dart';
import 'package:mioamoreapp/views/tabs/messages/components/chat_page.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:mioamoreapp/helpers/constants.dart';
import 'package:mioamoreapp/models/user_interaction_model.dart';
import 'package:mioamoreapp/models/user_profile_model.dart';
import 'package:mioamoreapp/providers/interaction_provider.dart';
import 'package:mioamoreapp/providers/other_users_provider.dart';
import 'package:mioamoreapp/providers/user_profile_provider.dart';
import 'package:mioamoreapp/views/custom/custom_app_bar.dart';
import 'package:mioamoreapp/views/custom/custom_icon_button.dart';
import 'package:mioamoreapp/views/others/user_card_widget.dart';
import 'package:mioamoreapp/views/settings/account_settings.dart';
import 'package:mioamoreapp/views/tabs/home/app_drawer.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _menuKey = GlobalKey();
  final _locationKey = GlobalKey();
  final _notificationKey = GlobalKey();

  final List<TargetFocus> _targets = [];

  @override
  void initState() {
    final showGuidedTour = Hive.box(HiveConstants.hiveBox)
        .get(HiveConstants.guidedTour, defaultValue: true) as bool;

    if (showGuidedTour) {
      Future.delayed(const Duration(milliseconds: 500), () async {
        _showTutorials();
        await setShowGuidedTour(false);
      });
    }

    super.initState();
  }

  void _showTutorials() {
    _targets.clear();
    _targets.add(
      TargetFocus(
        identify: "Menu",
        keyTarget: _menuKey,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Menu",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "You will find account settings, notifications, logout and others here...",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );

    _targets.add(
      TargetFocus(
        identify: "Location",
        keyTarget: _locationKey,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Location",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Click here to change your location...",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );

    _targets.add(
      TargetFocus(
        identify: "Notification",
        keyTarget: _notificationKey,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Notifications",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "You will find notifications here...",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );

    TutorialCoachMark(
      targets: _targets,
      colorShadow: AppConstants.primaryColor,
      onClickTarget: (target) {
        print(target);
      },
      onClickTargetWithTapPosition: (target, tapDetails) {
        print("target: $target");
        print(
            "clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
      },
      onClickOverlay: (target) {
        print(target);
      },
      onSkip: () {
        print("skip");
      },
      onFinish: () {
        print("finish");
      },
    ).show(context: context);
  }

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
                key: _menuKey,
                icon: CupertinoIcons.square_grid_2x2_fill,
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
                padding: const EdgeInsets.all(
                    AppConstants.defaultNumericValue / 1.5),
              ),
              title: Consumer(
                key: _locationKey,
                builder: (context, ref, _) {
                  final user = ref.watch(userProfileFutureProvider);
                  return user.when(
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
                                            AppConstants.defaultNumericValue /
                                                3),
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
                },
              ),
              trailing: NotificationButton(key: _notificationKey),
            ),
            Expanded(
              child: Consumer(
                builder: (context, ref, child) {
                  final filteredUsers = ref.watch(filteredOtherUsersProvider);

                  return filteredUsers.when(
                    data: (data) {
                      return data.isEmpty
                          ? const Center(child: Text("Nothing found"))
                          : FilterInteraction(
                              users: data,
                            );
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

class NotificationButton extends ConsumerWidget {
  const NotificationButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final matchingNotifications = ref.watch(notificationsStreamProvider);

    int count = 0;

    matchingNotifications.whenData((value) {
      for (var element in value) {
        if (element.isRead == false) {
          count++;
        }
      }
    });

    return Stack(
      children: [
        CustomIconButton(
          icon: CupertinoIcons.bell_solid,
          margin: count > 0
              ? const EdgeInsets.only(
                  right: AppConstants.defaultNumericValue / 3)
              : null,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NotificationPage(),
              ),
            );
          },
          padding: const EdgeInsets.all(AppConstants.defaultNumericValue / 1.5),
        ),
        if (count > 0)
          Positioned(
            bottom: 0,
            right: 0,
            child: Badge(
              badgeColor: AppConstants.primaryColor,
              badgeContent: Text(
                count.toString(),
                style: Theme.of(context).textTheme.caption!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
      ],
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
    final interactionProvider = ref.watch(interactionFutureProvider);

    return interactionProvider.when(
      data: (data) {
        final List<UserProfileModel> filteredUsers = [];

        for (final user in users) {
          if (!data.any(
              (element) => element.intractToUserId.contains(user.userId))) {
            filteredUsers.add(user);
          }
        }

        return filteredUsers.isEmpty
            ? const NotFoundUsersWidget()
            : HomeBody(
                users: filteredUsers,
              );
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
    final users = widget.users;
    users.shuffle();

    for (var user in widget.users) {
      _swipeItems.add(
        SwipeItem(
          content: user,
          likeAction: () {},
          nopeAction: () {},
          superlikeAction: () {},
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

  void createInteractionNotification(
      {required String title,
      required String body,
      required String receiverId,
      required UserProfileModel currentUser}) async {
    final currentTime = DateTime.now();
    final id = currentTime.millisecondsSinceEpoch.toString();
    final NotificationModel notificationModel = NotificationModel(
      id: id,
      userId: currentUser.userId,
      receiverId: receiverId,
      title: title,
      body: body,
      image: currentUser.profilePicture,
      createdAt: currentTime,
      isRead: false,
      isMatchingNotification: false,
      isInteractionNotification: true,
    );

    await addNotification(notificationModel);
  }

  void showMatchingDialog(
      {required BuildContext context,
      required UserProfileModel currentUser,
      required UserProfileModel otherUser}) async {
    final MatchModel matchModel = MatchModel(
      id: currentUser.userId + otherUser.userId,
      userIds: [currentUser.userId, otherUser.userId],
    );

    await createConversation(matchModel).then((matchResult) async {
      if (matchResult) {
        final currentTime = DateTime.now();
        final id =
            matchModel.id + currentTime.millisecondsSinceEpoch.toString();
        final NotificationModel notificationModel = NotificationModel(
          id: id,
          userId: currentUser.userId,
          receiverId: otherUser.userId,
          matchId: matchModel.id,
          title: currentUser.fullName,
          body: "You have a new match",
          image: currentUser.profilePicture,
          createdAt: currentTime,
          isRead: false,
          isMatchingNotification: true,
          isInteractionNotification: false,
        );

        await addNotification(notificationModel).then((value) async {
          await showDialog(
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
                      UserCirlePicture(
                          imageUrl: otherUser.profilePicture, size: 40),
                      const SizedBox(
                          width: AppConstants.defaultNumericValue / 4),
                      UserCirlePicture(
                          imageUrl: currentUser.profilePicture, size: 40),
                    ],
                  ),
                  const SizedBox(height: AppConstants.defaultNumericValue),
                  Center(
                    child:
                        Text("You are now matched with ${otherUser.fullName}"),
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
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ChatPage(
                                    matchId: matchModel.id,
                                    otherUserId: otherUser.userId,
                                  ),
                                ),
                              );
                            },
                            child: const Text("Start Chat")),
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUserProfile = ref.watch(userProfileFutureProvider);

    return currentUserProfile.when(
        data: (data) {
          if (data == null) {
            return const SizedBox();
          } else {
            return Center(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.72,
                width: MediaQuery.of(context).size.width * 0.95,
                child: SwipeCards(
                  upSwipeAllowed: true,
                  matchEngine: _matchEngine,
                  onStackFinished: () {
                    ref.invalidate(interactionFutureProvider);
                  },
                  itemBuilder: (context, index) {
                    final user = _swipeItems[index].content as UserProfileModel;

                    final String myUserId =
                        ref.watch(currentUserStateProvider)!.uid;
                    final String id = myUserId + user.id;

                    final UserInteractionModel interaction =
                        UserInteractionModel(
                      id: id,
                      userId: myUserId,
                      intractToUserId: user.id,
                      isSuperLike: false,
                      isLike: false,
                      isDislike: false,
                      createdAt: DateTime.now(),
                    );

                    return UserCardWidget(
                      user: _swipeItems[index].content,
                      onTapBolt: () async {
                        _matchEngine.currentItem?.superLike();
                        final newInteraction = interaction.copyWith(
                            isSuperLike: true, createdAt: DateTime.now());

                        await createInteraction(newInteraction)
                            .then((result) async {
                          if (result) {
                            await getExistingInteraction(user.id, myUserId)
                                .then((otherUserInteraction) {
                              if (otherUserInteraction != null) {
                                showMatchingDialog(
                                    context: context,
                                    currentUser: data,
                                    otherUser: user);
                              } else {
                                createInteractionNotification(
                                    title: "You have a new Interaction!",
                                    body: "Someone has super liked you!",
                                    receiverId: user.id,
                                    currentUser: data);
                              }
                            });
                          }
                        });
                      },
                      onTapCross: () async {
                        _matchEngine.currentItem?.nope();
                        final newInteraction = interaction.copyWith(
                            isDislike: true, createdAt: DateTime.now());
                        await createInteraction(newInteraction);
                      },
                      onTapHeart: () async {
                        _matchEngine.currentItem?.like();
                        final newInteraction = interaction.copyWith(
                            isLike: true, createdAt: DateTime.now());
                        await createInteraction(newInteraction)
                            .then((result) async {
                          if (result) {
                            await getExistingInteraction(user.id, myUserId)
                                .then((otherUserInteraction) {
                              if (otherUserInteraction != null) {
                                showMatchingDialog(
                                    context: context,
                                    currentUser: data,
                                    otherUser: user);
                              } else {
                                createInteractionNotification(
                                    title: "You have a new Interaction!",
                                    body: "Someone has liked you!",
                                    receiverId: user.id,
                                    currentUser: data);
                              }
                            });
                          }
                        });
                      },
                    );
                  },
                ),
              ),
            );
          }
        },
        error: (_, __) => const SizedBox(),
        loading: () => const SizedBox());
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
    final newSize = size ?? AppConstants.defaultNumericValue * 5;
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
          width: size,
          height: size,
          child: imageUrl == null || imageUrl!.isEmpty
              ? CircleAvatar(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  child: Icon(
                    CupertinoIcons.person_fill,
                    color: AppConstants.primaryColor,
                    size: newSize * 0.8,
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

class NotFoundUsersWidget extends ConsumerWidget {
  const NotFoundUsersWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notFoundUsersFuture = ref.watch(notShowingUsersProvider);
    return Center(
        child: Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.defaultNumericValue * 2),
      child: Text(
        notFoundUsersFuture,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headline6,
      ),
    ));
  }
}
