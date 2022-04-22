import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mio_amore/views/tabs/profile/edit_profile_page.dart';
import 'package:intl/intl.dart';
import 'package:mio_amore/helpers/constants.dart';
import 'package:mio_amore/models/user_profile_model.dart';
import 'package:mio_amore/providers/user_profile_provider.dart';
import 'package:mio_amore/views/custom/custom_app_bar.dart';
import 'package:mio_amore/views/custom/custom_headline.dart';
import 'package:mio_amore/views/custom/custom_icon_button.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final _userProfileProvider = ref.watch(userProfileStreamProvider);
    return Scaffold(
      backgroundColor: AppConstants.primaryColor,
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: AppConstants.primaryColor,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              const SizedBox(height: AppConstants.defaultNumericValue),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.defaultNumericValue),
                child: CustomAppBar(
                  leading: const SizedBox(
                      width: AppConstants.defaultNumericValue * 2),
                  title: const Center(
                    child: CustomHeadLine(
                      text: 'Profile',
                      secondPartColor: Colors.white,
                    ),
                  ),
                  trailing: _userProfileProvider.when(
                      data: (data) => data == null
                          ? const SizedBox()
                          : CustomIconButton(
                              icon: Icons.edit,
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditProfilePage(
                                            userProfileModel: data),
                                        fullscreenDialog: true));
                              },
                              padding: const EdgeInsets.all(
                                  AppConstants.defaultNumericValue / 1.5),
                            ),
                      error: (_, __) => const SizedBox(),
                      loading: () => const SizedBox()),
                ),
              ),
              const SizedBox(height: AppConstants.defaultNumericValue * 2),
            ],
          ),
          Expanded(
            child: _userProfileProvider.when(
              data: (data) {
                return data == null
                    ? const Center(child: Text("Not Available"))
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Column(
                                  children: [
                                    const SizedBox(
                                        height:
                                            AppConstants.defaultNumericValue *
                                                4),
                                    Center(
                                      child: ClipRRect(
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(
                                              sigmaX: 10, sigmaY: 10),
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      AppConstants
                                                          .defaultNumericValue),
                                              color: Colors.white12,
                                            ),
                                            padding: const EdgeInsets.all(
                                                AppConstants
                                                    .defaultNumericValue),
                                            child: Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  const SizedBox(
                                                      height: AppConstants
                                                              .defaultNumericValue *
                                                          4),
                                                  Text(
                                                    data.fullName,
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                      fontSize: AppConstants
                                                              .defaultNumericValue *
                                                          1.2,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                      height: AppConstants
                                                              .defaultNumericValue /
                                                          2),
                                                  Text(
                                                    data.email ?? "",
                                                    textAlign: TextAlign.center,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .caption!
                                                        .copyWith(
                                                            color:
                                                                Colors.white70),
                                                  ),
                                                  const SizedBox(
                                                      height: AppConstants
                                                          .defaultNumericValue),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          AppConstants.defaultNumericValue *
                                              10),
                                      border: Border.all(
                                          color: AppConstants.primaryColor,
                                          width:
                                              AppConstants.defaultNumericValue /
                                                  2),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          AppConstants.defaultNumericValue *
                                              10),
                                      child: SizedBox(
                                        width:
                                            AppConstants.defaultNumericValue *
                                                7,
                                        height:
                                            AppConstants.defaultNumericValue *
                                                7,
                                        child: data.profilePicture == null ||
                                                data.profilePicture!.isEmpty
                                            ? CircleAvatar(
                                                backgroundColor: Theme.of(
                                                        context)
                                                    .scaffoldBackgroundColor,
                                                child: Icon(
                                                  CupertinoIcons.person_fill,
                                                  color:
                                                      AppConstants.primaryColor,
                                                  size: AppConstants
                                                          .defaultNumericValue *
                                                      5,
                                                ),
                                              )
                                            : CachedNetworkImage(
                                                imageUrl: data.profilePicture!,
                                                placeholder: (context, url) =>
                                                    const Center(
                                                        child:
                                                            CircularProgressIndicator()),
                                                errorWidget: (context, url,
                                                        error) =>
                                                    const Center(
                                                        child:
                                                            Icon(Icons.error)),
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              height: AppConstants.defaultNumericValue * 4,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppConstants.primaryColor,
                                    Theme.of(context).scaffoldBackgroundColor,
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  stops: const [0.9, 1],
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Expanded(
                                      child: SizedBox(
                                    height:
                                        AppConstants.defaultNumericValue * 2,
                                  )),
                                  Expanded(
                                    child: Container(
                                      height:
                                          AppConstants.defaultNumericValue * 2,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(
                                              AppConstants.defaultNumericValue *
                                                  10),
                                          topRight: Radius.circular(
                                              AppConstants.defaultNumericValue *
                                                  10),
                                        ),
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            ProfileBottomPart(data: data),
                          ],
                        ),
                      );
              },
              error: (_, e) =>
                  const Center(child: Text("Something went wrong!")),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileBottomPart extends StatefulWidget {
  final UserProfileModel data;
  const ProfileBottomPart({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<ProfileBottomPart> createState() => _ProfileBottomPartState();
}

class _ProfileBottomPartState extends State<ProfileBottomPart> {
  final List<String> _tabs = ['About', 'Gallery'];
  int _selectedTabIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.defaultNumericValue * 2),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: _tabs.map((e) {
                  return Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedTabIndex = _tabs.indexOf(e);
                          });
                        },
                        child: Text(
                          e,
                          style:
                              Theme.of(context).textTheme.headline6!.copyWith(
                                    color: _selectedTabIndex == _tabs.indexOf(e)
                                        ? AppConstants.primaryColor
                                        : Colors.black54,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                      const SizedBox(
                          width: AppConstants.defaultNumericValue * 2),
                    ],
                  );
                }).toList()),
          ),
          const SizedBox(height: AppConstants.defaultNumericValue),
          _selectedTabIndex == 0
              ? UserAboutView(data: widget.data)
              : UserGalleryView(data: widget.data),
        ],
      ),
    );
  }
}

class UserAboutView extends StatelessWidget {
  final UserProfileModel data;
  const UserAboutView({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          title: const Text("Phone Number"),
          subtitle: Text(data.phoneNumber == null || data.phoneNumber!.isEmpty
              ? "Not Set!"
              : data.phoneNumber!),
        ),
        ListTile(
          title: const Text("About Me"),
          subtitle: Text(data.about == null || data.about!.isEmpty
              ? "Not Set!"
              : data.about!),
        ),
        ListTile(
          title: const Text("Birthday"),
          subtitle: Text(DateFormat("MM/dd/yyyy").format(data.birthDay)),
        ),
        ListTile(
          title: const Text("Gender"),
          subtitle: Text(data.gender.toUpperCase()),
        ),
        ListTile(
          title: const Text("Interests"),
          subtitle: data.interests.isEmpty
              ? const Text("Nothing Found!")
              : Wrap(
                  spacing: AppConstants.defaultNumericValue / 2,
                  children: data.interests
                      .map((interest) => Chip(
                            backgroundColor:
                                AppConstants.primaryColor.withOpacity(0.2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  AppConstants.defaultNumericValue * 2),
                              side: BorderSide(
                                  color: AppConstants.primaryColor, width: 1),
                            ),
                            label: Text(interest[0].toUpperCase() +
                                interest.substring(1)),
                          ))
                      .toList(),
                ),
        ),
        const SizedBox(height: AppConstants.defaultNumericValue * 8),
      ],
    );
  }
}

class UserGalleryView extends StatelessWidget {
  final UserProfileModel data;
  const UserGalleryView({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return data.mediaFiles.isEmpty
        ? SizedBox(
            child: const Center(child: Text("Nothing Found!")),
            height: MediaQuery.of(context).size.height / 2,
          )
        : GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(
              left: AppConstants.defaultNumericValue,
              right: AppConstants.defaultNumericValue,
              bottom: AppConstants.defaultNumericValue,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
              crossAxisSpacing: AppConstants.defaultNumericValue,
              mainAxisSpacing: AppConstants.defaultNumericValue,
            ),
            children: data.mediaFiles.map((e) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(AppConstants.defaultNumericValue),
                ),
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(AppConstants.defaultNumericValue),
                  child: CachedNetworkImage(
                      imageUrl: e,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const Center(child: CupertinoActivityIndicator()),
                      errorWidget: (context, url, error) {
                        return const Center(
                            child: Icon(Icons.image_not_supported));
                      }),
                ),
              );
            }).toList(),
          );
  }
}
