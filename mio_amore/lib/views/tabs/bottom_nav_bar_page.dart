import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mio_amore/helpers/constants.dart';
import 'package:mio_amore/models/user_profile_model.dart';
import 'package:mio_amore/providers/match_provider.dart';
import 'package:mio_amore/providers/user_profile_provider.dart';
import 'package:mio_amore/views/others/error_page.dart';
import 'package:mio_amore/views/others/loading_page.dart';
import 'package:mio_amore/views/tabs/favourites/favourites_page.dart';
import 'package:mio_amore/views/tabs/feeds/feeds_page.dart';
import 'package:mio_amore/views/tabs/home/home_page.dart';
import 'package:mio_amore/views/tabs/interactions/interactions_page.dart';
import 'package:mio_amore/views/tabs/messages/messages_page.dart';
import 'package:mio_amore/views/tabs/profile/edit_profile_page.dart';
import 'package:mio_amore/views/tabs/profile/first_time_update_profile_page.dart';

class BottomNavBarPage extends ConsumerStatefulWidget {
  const BottomNavBarPage({Key? key}) : super(key: key);

  @override
  ConsumerState<BottomNavBarPage> createState() => _BottomNavBarPageState();
}

class _BottomNavBarPageState extends ConsumerState<BottomNavBarPage> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  void _showCompleteProfile() async {
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      final userRef = ref.read(userProfileFutureProvider);

      UserProfileModel? userProfile;

      userRef.whenData((value) {
        userProfile = value;
      });

      if (userProfile != null) {
        final showCompleteDialog = Hive.box(HiveConstants.hiveBox)
            .get(HiveConstants.showCompleteDialog, defaultValue: false) as bool;

        if (!showCompleteDialog) {
          if (userProfile!.profilePicture == null) {
            await Future.delayed(const Duration(seconds: 3), () async {
              if (mounted) {
                await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Complete your profile'),
                        content: const Text(
                            'Please set your profile picture. You can also edit your profile after you have set your profile picture. Add some other photos to your profile to make it more interesting.'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('Okay'),
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => EditProfilePage(
                                      userProfileModel: userProfile!),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    }).then((value) {
                  Hive.box(HiveConstants.hiveBox)
                      .put(HiveConstants.showCompleteDialog, true);
                });
              }
            });
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // _showCompleteProfile();

    final isUserAdded = ref.watch(isUserAddedProvider);

    return isUserAdded.when(
      loading: () => const LoadingPage(),
      error: (e, _) => const ErrorPage(),
      data: (data) {
        return data
            ? Scaffold(
                body: PageTransitionSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder:
                      (child, primaryAnimation, secondaryAnimation) =>
                          FadeThroughTransition(
                    fillColor: Theme.of(context).scaffoldBackgroundColor,
                    animation: primaryAnimation,
                    secondaryAnimation: secondaryAnimation,
                    child: child,
                  ),
                  child: _navItems[_currentIndex].page,
                ),
                bottomNavigationBar: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        spreadRadius: 2,
                        offset: const Offset(0, -5),
                      ),
                    ],
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: AppConstants.defaultNumericValue / 3),
                    child: BottomNavigationBar(
                      unselectedLabelStyle: const TextStyle(
                          fontSize: 10, fontWeight: FontWeight.bold),
                      selectedLabelStyle: const TextStyle(
                          fontSize: 11, fontWeight: FontWeight.bold),
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      type: BottomNavigationBarType.fixed,
                      currentIndex: _currentIndex,
                      unselectedItemColor: Colors.grey,
                      selectedItemColor: AppConstants.primaryColor,
                      onTap: (index) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                      items: _navItems.map((e) {
                        return BottomNavigationBarItem(
                          icon: _navItems.indexOf(e) == 3
                              ? MessageConsumerBottomNavIcon(icon: e.icon)
                              : Icon(e.icon),
                          label: e.title,
                          activeIcon: _navItems.indexOf(e) == 3
                              ? MessageConsumerBottomNavIcon(icon: e.activeIcon)
                              : Icon(e.activeIcon),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              )
            : const FirstTimeUserProfilePage();
      },
    );
  }
}

class _BottomNavBarItem {
  final String title;
  final IconData icon;
  final IconData activeIcon;
  final Widget page;
  _BottomNavBarItem({
    required this.title,
    required this.icon,
    required this.activeIcon,
    required this.page,
  });
}

final List<_BottomNavBarItem> _navItems = [
  _BottomNavBarItem(
    title: 'Home',
    icon: CupertinoIcons.home,
    activeIcon: CupertinoIcons.home,
    page: const HomePage(),
  ),
  //Explore
  _BottomNavBarItem(
    title: 'Feeds',
    icon: Icons.explore_outlined,
    activeIcon: Icons.explore,
    page: const FeedsPage(),
  ),
  //Favourites
  _BottomNavBarItem(
    title: 'Matches',
    icon: CupertinoIcons.heart,
    activeIcon: CupertinoIcons.heart_solid,
    page: const MatchesConsumerPage(),
  ),
  //Messages
  _BottomNavBarItem(
    title: 'Message',
    icon: CupertinoIcons.mail,
    activeIcon: CupertinoIcons.mail_solid,
    page: const MessageConsumerPage(),
  ),
  //Proile
  _BottomNavBarItem(
    title: 'Interactions',
    icon: CupertinoIcons.cube_box,
    activeIcon: CupertinoIcons.cube_box_fill,
    page: const InteractionsPage(),
  ),
];

class MessageConsumerBottomNavIcon extends ConsumerWidget {
  final IconData icon;
  const MessageConsumerBottomNavIcon({
    Key? key,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matchStream = ref.watch(matchStreamProvider);

    return matchStream.when(
      data: (data) {
        final List<MessageViewModel> messages = [];

        messages.addAll(getAllMessages(ref, data));
        int unreadCount = 0;
        for (var e in messages) {
          unreadCount += e.unreadCount;
        }

        return MessageIcon(unreadCount: unreadCount, icon: icon);
      },
      error: (_, __) => MessageIcon(unreadCount: 0, icon: icon),
      loading: () => MessageIcon(unreadCount: 0, icon: icon),
    );
  }
}

class MessageIcon extends StatelessWidget {
  final int unreadCount;
  final IconData icon;
  const MessageIcon({
    Key? key,
    required this.unreadCount,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Icon(
          icon,
        ),
        if (unreadCount > 0)
          Positioned(
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(6),
              ),
              constraints: const BoxConstraints(minWidth: 12, minHeight: 12),
              child: Center(
                child: Text(
                  '$unreadCount',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 7,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
