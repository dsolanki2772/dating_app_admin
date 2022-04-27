import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mio_amore/helpers/constants.dart';
import 'package:mio_amore/models/user_profile_model.dart';
import 'package:mio_amore/providers/other_users_provider.dart';
import 'package:mio_amore/providers/user_profile_provider.dart';
import 'package:mio_amore/views/custom/custom_app_bar.dart';
import 'package:mio_amore/views/custom/custom_icon_button.dart';
import 'package:mio_amore/views/others/user_image_card.dart';
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
            Expanded(child: Consumer(
              builder: (context, ref, child) {
                final _filteredUsers = ref.watch(filteredOtherUsersProvider);

                return _filteredUsers.when(
                  data: (data) {
                    return data.isEmpty
                        ? const SizedBox()
                        : HomeBody(users: data);
                  },
                  error: (_, __) => const Center(
                    child: Text("Something Went Wrong!"),
                  ),
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            )),
          ],
        ),
      ),
    );
  }
}

class HomeBody extends StatefulWidget {
  final List<UserProfileModel> users;
  const HomeBody({
    Key? key,
    required this.users,
  }) : super(key: key);

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  late MatchEngine _matchEngine;
  List<SwipeItem> _swipeItems = [];

  @override
  void initState() {
    for (var user in widget.users) {
      _swipeItems.add(
        SwipeItem(
          content: user,
          likeAction: () {
            print("Liked");
          },
          nopeAction: () {
            print("Noped");
          },
          superlikeAction: () {
            print("Super Liked");
          },
          // onSlideUpdate: (region) async {
          //   print(region);
          // },
        ),
      );
    }

    _matchEngine = MatchEngine(swipeItems: _swipeItems);

    super.initState();
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
            print("Stack Finished");
          },
          itemBuilder: (context, index) {
            return UserImageCard(user: _swipeItems[index].content);
          },
        ),
      ),
    );
  }
}
