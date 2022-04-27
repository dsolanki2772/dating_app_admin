import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mio_amore/helpers/constants.dart';
import 'package:mio_amore/models/user_profile_model.dart';
import 'package:mio_amore/providers/favourite_users_provider.dart';
import 'package:mio_amore/views/custom/custom_icon_button.dart';
import 'package:mio_amore/views/others/photo_view_page.dart';

class UserDetailsPage extends StatelessWidget {
  final UserProfileModel user;
  const UserDetailsPage({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: AppConstants.defaultNumericValue * 28,
                      width: MediaQuery.of(context).size.width,
                      child: (user.profilePicture == null &&
                              user.mediaFiles.isEmpty)
                          ? const Center(
                              child: Icon(CupertinoIcons.photo),
                            )
                          : GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PhotoViewPage(
                                      images: [
                                        user.profilePicture != null
                                            ? user.profilePicture!
                                            : user.mediaFiles.isNotEmpty
                                                ? user.mediaFiles.first
                                                : ''
                                      ],
                                      title: "Photos",
                                    ),
                                  ),
                                );
                              },
                              child: CachedNetworkImage(
                                imageUrl: user.profilePicture != null
                                    ? user.profilePicture!
                                    : user.mediaFiles.isNotEmpty
                                        ? user.mediaFiles.first
                                        : '',
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const Center(
                                    child: CupertinoActivityIndicator()),
                                errorWidget: (context, url, error) {
                                  return const Center(
                                      child: Icon(CupertinoIcons.photo));
                                },
                              ),
                            ),
                    ),
                    Container(
                        height: 2,
                        color: Theme.of(context).scaffoldBackgroundColor)
                  ],
                ),
                //Top Bar
                Positioned(
                  top: AppConstants.defaultNumericValue * 3,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.defaultNumericValue),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomIconButton(
                          icon: CupertinoIcons.chevron_back,
                          color: Colors.white,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          padding: const EdgeInsets.all(
                              AppConstants.defaultNumericValue / 1.5),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _AddToFavButton(user: user),
                            const SizedBox(
                                width: AppConstants.defaultNumericValue / 2),
                            CustomIconButton(
                              icon: CupertinoIcons.bell_fill,
                              color: Colors.white,
                              onPressed: () {},
                              padding: const EdgeInsets.all(
                                  AppConstants.defaultNumericValue / 1.5),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: AppConstants.defaultNumericValue * 2,
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(
                            AppConstants.defaultNumericValue * 2),
                        topRight: Radius.circular(
                            AppConstants.defaultNumericValue * 2),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.defaultNumericValue),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user.fullName,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(fontWeight: FontWeight.bold)),
                            const SizedBox(
                                height: AppConstants.defaultNumericValue / 4),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.location_on,
                                    color: AppConstants.primaryColor, size: 16),
                                const SizedBox(
                                    width:
                                        AppConstants.defaultNumericValue / 4),
                                Flexible(
                                  child: Text(
                                      user.userAccountSettingsModel.location
                                          .addressText,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2!
                                          .copyWith(
                                              color: AppConstants.primaryColor,
                                              fontWeight: FontWeight.bold)),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      const SizedBox(width: AppConstants.defaultNumericValue),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppConstants.defaultNumericValue,
                            vertical: AppConstants.defaultNumericValue / 2),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(AppConstants.defaultNumericValue),
                          ),
                          gradient: AppConstants.defaultGradient,
                        ),
                        child: Text(
                            "${DateTime.now().difference(user.birthDay).inDays ~/ 365} Years",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppConstants.defaultNumericValue),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.defaultNumericValue),
                  child: Text(
                    "About",
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: AppConstants.defaultNumericValue / 2),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.defaultNumericValue),
                  child: Text(user.about == null || user.about!.isEmpty
                      ? "Not Available"
                      : user.about!),
                ),
                const SizedBox(height: AppConstants.defaultNumericValue),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.defaultNumericValue),
                  child: Text(
                    "Interests",
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: AppConstants.defaultNumericValue / 2),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.defaultNumericValue),
                  child: user.interests.isEmpty
                      ? const Text("Not Found!")
                      : Wrap(
                          spacing: AppConstants.defaultNumericValue / 2,
                          runSpacing: AppConstants.defaultNumericValue / 2,
                          alignment: WrapAlignment.start,
                          children: user.interests.map((interest) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(
                                      AppConstants.defaultNumericValue / 2),
                                ),
                                color:
                                    AppConstants.primaryColor.withOpacity(0.1),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppConstants.defaultNumericValue,
                                  vertical:
                                      AppConstants.defaultNumericValue / 2),
                              child: Text(interest[0].toUpperCase() +
                                  interest.substring(1)),
                            );
                          }).toList()),
                ),
                const SizedBox(height: AppConstants.defaultNumericValue),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.defaultNumericValue),
                  child: Text(
                    "Photos",
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: AppConstants.defaultNumericValue / 2),
                user.mediaFiles.isEmpty
                    ? const SizedBox(
                        height: 200,
                        child: Center(
                            child: Text(
                          "No Photos Found!",
                          textAlign: TextAlign.center,
                        )),
                      )
                    : GridView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(
                          left: AppConstants.defaultNumericValue,
                          right: AppConstants.defaultNumericValue,
                          bottom: AppConstants.defaultNumericValue,
                        ),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1,
                          crossAxisSpacing: AppConstants.defaultNumericValue,
                          mainAxisSpacing: AppConstants.defaultNumericValue,
                        ),
                        children: user.mediaFiles.map((e) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PhotoViewPage(
                                    images: user.mediaFiles,
                                    title: "Photos",
                                    index: user.mediaFiles.indexOf(e),
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                    AppConstants.defaultNumericValue),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    AppConstants.defaultNumericValue),
                                child: CachedNetworkImage(
                                    imageUrl: e,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => const Center(
                                        child: CupertinoActivityIndicator()),
                                    errorWidget: (context, url, error) {
                                      return const Center(
                                          child:
                                              Icon(Icons.image_not_supported));
                                    }),
                              ),
                            ),
                          );
                        }).toList())
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AddToFavButton extends ConsumerWidget {
  final UserProfileModel user;
  const _AddToFavButton({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final _favouriteUsersStreamProvider =
        ref.watch(favouriteUsersStreamProvider);
    return _favouriteUsersStreamProvider.when(
        data: (data) {
          bool _isFavorite = data.contains(user.id);

          return CustomIconButton(
            icon:
                _isFavorite ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
            color: _isFavorite ? CupertinoColors.systemRed : Colors.white,
            onPressed: () {
              if (_isFavorite) {
                ref.read(favouriteUsersProvider).removeFromFavourite(user.id);
              } else {
                ref.read(favouriteUsersProvider).addToFavourite(user.id);
              }
            },
            padding:
                const EdgeInsets.all(AppConstants.defaultNumericValue / 1.5),
          );
        },
        error: (_, __) => const SizedBox(),
        loading: () => const SizedBox());
  }
}
