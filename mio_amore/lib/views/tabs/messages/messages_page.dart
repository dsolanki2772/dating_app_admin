import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mio_amore/helpers/constants.dart';
import 'package:mio_amore/views/custom/custom_app_bar.dart';
import 'package:mio_amore/views/custom/custom_headline.dart';
import 'package:mio_amore/views/custom/custom_icon_button.dart';
import 'package:mio_amore/views/tabs/messages/components/chat_page.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({Key? key}) : super(key: key);

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  bool _isSearchBarVisible = false;
  final _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
            child: SingleChildScrollView(
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
                                color:
                                    AppConstants.primaryColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(
                                  AppConstants.defaultNumericValue,
                                ),
                              ),
                              child: TextField(
                                controller: _searchController,
                                autofocus: true,
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
                  SizedBox(
                    height: AppConstants.defaultNumericValue * 4,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      children: [
                        for (var i = 0; i < 30; i++)
                          Stack(
                            children: [
                              Container(
                                width: AppConstants.defaultNumericValue * 4,
                                margin: EdgeInsets.only(
                                  right: AppConstants.defaultNumericValue / 2,
                                  left: i == 0
                                      ? AppConstants.defaultNumericValue
                                      : 0,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      AppConstants.defaultNumericValue * 4),
                                  border: Border.all(
                                    color: AppConstants.primaryColor
                                        .withOpacity(0.4),
                                    width: 1.5,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      AppConstants.defaultNumericValue * 10),
                                  child: CachedNetworkImage(
                                    imageUrl: defaultImage,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: AppConstants.defaultNumericValue / 4,
                                right: AppConstants.defaultNumericValue / 2,
                                child: Badge(
                                  badgeColor: AppConstants.primaryColor,
                                  elevation: 0,
                                  animationType: BadgeAnimationType.scale,
                                  borderSide: const BorderSide(
                                      color: Colors.white70, width: 1.5),
                                  padding: const EdgeInsets.all(
                                      AppConstants.defaultNumericValue / 2.5),
                                ),
                              )
                            ],
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppConstants.defaultNumericValue * 2),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.defaultNumericValue),
                    child: Text(
                      "Messages",
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: AppConstants.defaultNumericValue),
                  Column(
                    children: [
                      for (var i = 0; i < 100; i++)
                        Column(
                          children: [
                            ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => const ChatPage()),
                                );
                              },
                              title: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "John Doe",
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1!
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                  const SizedBox(
                                      width: AppConstants.defaultNumericValue),
                                  Text(
                                    "12:00 PM",
                                    style:
                                        Theme.of(context).textTheme.subtitle1!,
                                  ),
                                ],
                              ),
                              subtitle: const Text(
                                "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              leading: Container(
                                width: AppConstants.defaultNumericValue * 3,
                                height: AppConstants.defaultNumericValue * 3,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      AppConstants.defaultNumericValue * 4),
                                  border: Border.all(
                                    color: AppConstants.primaryColor
                                        .withOpacity(0.4),
                                    width: 1.5,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      AppConstants.defaultNumericValue * 10),
                                  child: CachedNetworkImage(
                                    imageUrl: profilePicture,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            const Divider(
                              height: 0,
                              indent: AppConstants.defaultNumericValue,
                              endIndent: AppConstants.defaultNumericValue,
                            ),
                          ],
                        )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
