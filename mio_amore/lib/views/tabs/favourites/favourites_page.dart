import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mio_amore/helpers/constants.dart';
import 'package:mio_amore/models/user_profile_model.dart';
import 'package:mio_amore/providers/favourite_users_provider.dart';
import 'package:mio_amore/providers/other_users_provider.dart';
import 'package:mio_amore/views/custom/custom_app_bar.dart';
import 'package:mio_amore/views/custom/custom_headline.dart';
import 'package:mio_amore/views/custom/custom_icon_button.dart';
import 'package:mio_amore/views/others/user_image_card.dart';

class FavouritesPage extends ConsumerWidget {
  const FavouritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final _favouriteUsersProvider = ref.watch(favouriteUsersStreamProvider);
    final _otherUsersProvider = ref.watch(otherUsersProvider);
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
                onPressed: () {},
                padding: const EdgeInsets.all(
                    AppConstants.defaultNumericValue / 1.5),
              ),
              title: Center(
                  child: CustomHeadLine(
                text: 'Favourites',
                secondPartColor: AppConstants.primaryColor,
              )),
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
          const SizedBox(height: AppConstants.defaultNumericValue),
          Expanded(
            child: _otherUsersProvider.when(
              data: (data) {
                if (data.isEmpty) {
                  return const Center(
                    child: Text(
                      'No users found',
                      textAlign: TextAlign.center,
                    ),
                  );
                } else {
                  return _favouriteUsersProvider.when(
                      data: (favourites) {
                        final List<UserProfileModel> _favUsers = [];

                        for (final user in data) {
                          if (favourites.contains(user.id)) {
                            _favUsers.add(user);
                          }
                        }
                        if (_favUsers.isEmpty) {
                          return const Center(
                            child: Text(
                              'No users found',
                              textAlign: TextAlign.center,
                            ),
                          );
                        } else {
                          return GridView(
                            padding: const EdgeInsets.only(
                              left: AppConstants.defaultNumericValue,
                              right: AppConstants.defaultNumericValue,
                              bottom: AppConstants.defaultNumericValue,
                            ),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.75,
                              crossAxisSpacing:
                                  AppConstants.defaultNumericValue,
                              mainAxisSpacing: AppConstants.defaultNumericValue,
                            ),
                            children: _favUsers.map((u) {
                              return UserImageCard(user: u, isFavorite: true);
                            }).toList(),
                          );
                        }
                      },
                      error: (_, __) => const Center(
                            child: Text(
                              "Something Went Wrong!",
                              textAlign: TextAlign.center,
                            ),
                          ),
                      loading: () => const Center(
                            child: CircularProgressIndicator(),
                          ));
                }
              },
              error: (_, __) => const Center(
                child: Text(
                  "Something Went Wrong!",
                  textAlign: TextAlign.center,
                ),
              ),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
