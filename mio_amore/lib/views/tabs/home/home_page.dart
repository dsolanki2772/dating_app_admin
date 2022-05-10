import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mio_amore/helpers/constants.dart';
import 'package:mio_amore/models/user_interaction_model.dart';
import 'package:mio_amore/models/user_profile_model.dart';
import 'package:mio_amore/providers/other_users_provider.dart';
import 'package:mio_amore/providers/user_interaction_provider.dart';
import 'package:mio_amore/providers/user_profile_provider.dart';
import 'package:mio_amore/views/custom/custom_app_bar.dart';
import 'package:mio_amore/views/custom/custom_icon_button.dart';
import 'package:mio_amore/views/others/user_card_widget.dart';
import 'package:mio_amore/views/settings/account_settings.dart';
import 'package:mio_amore/views/tabs/home/app_drawer.dart';
import 'package:swipe_cards/swipe_cards.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    final _intercationProvider = ref.watch(userIneractionFutureProvider);
    return _intercationProvider.when(
      data: (data) {
        final List<UserProfileModel> _filteredUsers = [];
        final List<UserInteractionModel> _existingInteractions = [];

        for (final user in users) {
          if (!data.any((element) => element.userIds.contains(user.userId)) ||
              data.any((element) => element.interactions.any(
                  (i) => i.userId != FirebaseAuth.instance.currentUser!.uid))) {
            _filteredUsers.add(user);
          }

          if (data.any((element) => element.interactions.any(
              (i) => i.userId != FirebaseAuth.instance.currentUser!.uid))) {
            _existingInteractions.add(data.firstWhere((element) =>
                element.interactions.any((i) =>
                    i.userId != FirebaseAuth.instance.currentUser!.uid)));
          }
        }

        return _filteredUsers.isEmpty
            ? const Center(child: Text("No User Found!"))
            : HomeBody(
                users: _filteredUsers, interactions: _existingInteractions);
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
  final List<UserInteractionModel> interactions;

  const HomeBody({
    Key? key,
    required this.users,
    required this.interactions,
  }) : super(key: key);

  @override
  ConsumerState<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends ConsumerState<HomeBody> {
  late MatchEngine _matchEngine;
  final List<SwipeItem> _swipeItems = [];
  bool _isFinished = false;

  List<UserInteractionModel> _existingInteractions = [];

  @override
  void initState() {
    final _userInteractionProvider = ref.read(userInteractionProvider);

    _existingInteractions = widget.interactions;

    for (var user in widget.users) {
      final String _myUserId = FirebaseAuth.instance.currentUser!.uid;
      final String _id = user.userId + _myUserId;
      final List<String> _userIds = [
        user.userId,
        FirebaseAuth.instance.currentUser!.uid
      ];

      final UserInteractionModel _interaction = UserInteractionModel(
        id: _id,
        interactions: [],
        userIds: _userIds,
        createdAt: DateTime.now(),
      );

      UserInteractionModel? _existedUserInteraction;

      if (_existingInteractions.any((element) =>
          element.id == _myUserId + user.userId ||
          element.id == user.userId + _myUserId)) {
        _existedUserInteraction = _existingInteractions.firstWhere((element) =>
            element.id == _myUserId + user.userId ||
            element.id == user.userId + _myUserId);
      }

      _swipeItems.add(
        SwipeItem(
          content: user,
          likeAction: () {
            final InteractionUser _interactionUser = InteractionUser(
              userId: _myUserId,
              isDisliked: false,
              isLiked: true,
              isSuperliked: false,
            );
            if (_existedUserInteraction != null) {
              _existedUserInteraction.interactions.add(_interactionUser);
              _userInteractionProvider
                  .updateUserInteraction(_existedUserInteraction);
            } else {
              _interaction.interactions.add(_interactionUser);
              _userInteractionProvider.createUserInteraction(_interaction);
            }
          },
          nopeAction: () {
            final InteractionUser _interactionUser = InteractionUser(
              userId: _myUserId,
              isDisliked: true,
              isLiked: false,
              isSuperliked: false,
            );

            if (_existedUserInteraction != null) {
              _existedUserInteraction.interactions.add(_interactionUser);
              _userInteractionProvider
                  .updateUserInteraction(_existedUserInteraction);
            } else {
              _interaction.interactions.add(_interactionUser);
              _userInteractionProvider.createUserInteraction(_interaction);
            }
          },
          superlikeAction: () {
            final InteractionUser _interactionUser = InteractionUser(
              userId: _myUserId,
              isDisliked: false,
              isLiked: false,
              isSuperliked: true,
            );
            if (_existedUserInteraction != null) {
              _existedUserInteraction.interactions.add(_interactionUser);
              _userInteractionProvider
                  .updateUserInteraction(_existedUserInteraction);
            } else {
              _interaction.interactions.add(_interactionUser);
              _userInteractionProvider.createUserInteraction(_interaction);
            }
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
        child: _isFinished
            ? const Center(child: Text("No More User Found!"))
            : SwipeCards(
                upSwipeAllowed: true,
                matchEngine: _matchEngine,
                onStackFinished: () {
                  setState(() {
                    _isFinished = true;
                  });
                },
                itemBuilder: (context, index) {
                  return UserCardWidget(
                    user: _swipeItems[index].content,
                    onTapBolt: () {
                      _matchEngine.currentItem?.superLike();
                    },
                    onTapCross: () {
                      _matchEngine.currentItem?.nope();
                    },
                    onTapHeart: () {
                      _matchEngine.currentItem?.like();
                    },
                  );
                },
              ),
      ),
    );
  }
}
