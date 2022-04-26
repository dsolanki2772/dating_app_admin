import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mio_amore/helpers/constants.dart';
import 'package:mio_amore/providers/auth_providers.dart';
import 'package:mio_amore/providers/user_profile_provider.dart';
import 'package:mio_amore/views/custom/custom_icon_button.dart';
import 'package:mio_amore/views/settings/account_settings.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final _userProfileProvider = ref.watch(userProfileStreamProvider);
    return Drawer(
      backgroundColor: AppConstants.primaryColor,
      child: Column(
        children: [
          _userProfileProvider.when(
              data: (data) {
                return data == null
                    ? const SizedBox()
                    : DrawerHeader(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            CustomIconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: CupertinoIcons.clear,
                              padding: const EdgeInsets.all(
                                  AppConstants.defaultNumericValue / 2),
                              color: Colors.white70,
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              minLeadingWidth: 0,
                              title: Text(
                                data.fullName,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                data.email ?? data.phoneNumber ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.white70),
                              ),
                              leading: CircleAvatar(
                                child: data.profilePicture == null
                                    ? const Icon(Icons.person,
                                        color: Colors.white54)
                                    : null,
                                backgroundImage: data.profilePicture != null
                                    ? CachedNetworkImageProvider(
                                        data.profilePicture!)
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      );
              },
              error: (_, __) => const SizedBox(),
              loading: () => const SizedBox()),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  DrawerItem(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const AccountSettingsLandingWidget(),
                              fullscreenDialog: true));
                    },
                    title: 'Account Settings',
                    leadingIcon: CupertinoIcons.profile_circled,
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: AppConstants.defaultNumericValue / 2),
                  DrawerItem(
                    onPressed: () {},
                    title: 'Notifications',
                    leadingIcon: CupertinoIcons.bell_solid,
                    trailing: const Icon(
                      Icons.toggle_off,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: AppConstants.defaultNumericValue / 2),
                  DrawerItem(
                    onPressed: () {},
                    title: 'Security',
                    leadingIcon: CupertinoIcons.lock_circle,
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: AppConstants.defaultNumericValue / 2),
                  DrawerItem(
                    onPressed: () {},
                    title: 'Language',
                    leadingIcon: CupertinoIcons.globe,
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: AppConstants.defaultNumericValue / 2),
                  DrawerItem(
                    onPressed: () {},
                    title: 'Linked Accounts',
                    leadingIcon: CupertinoIcons.person_solid,
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: AppConstants.defaultNumericValue / 2),
                  DrawerItem(
                    onPressed: () {},
                    title: 'Help Center',
                    leadingIcon: CupertinoIcons.question_circle_fill,
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: AppConstants.defaultNumericValue / 2),
                  DrawerItem(
                    onPressed: () {},
                    title: 'About Us',
                    leadingIcon: CupertinoIcons.info_circle_fill,
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),
          DrawerItem(
            leadingIcon: CupertinoIcons.power,
            onPressed: () {
              ref.read(authProvider).signOut();
            },
            title: 'Log Out',
          ),
          const SizedBox(height: AppConstants.defaultNumericValue / 2),
        ],
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData leadingIcon;
  final Widget? trailing;
  final String title;
  const DrawerItem({
    Key? key,
    required this.onPressed,
    required this.leadingIcon,
    this.trailing,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultNumericValue),
      ),
      title: Text(
        title,
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      onTap: onPressed,
      leading: Container(
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(AppConstants.defaultNumericValue),
        ),
        padding: const EdgeInsets.all(AppConstants.defaultNumericValue / 1.5),
        child: Icon(leadingIcon, color: Colors.white),
      ),
      trailing: trailing,
    );
  }
}
