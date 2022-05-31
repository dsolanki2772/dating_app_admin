import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mio_amore/helpers/constants.dart';
import 'package:mio_amore/models/user_profile_model.dart';
import 'package:mio_amore/providers/match_provider.dart';
import 'package:mio_amore/providers/other_users_provider.dart';
import 'package:mio_amore/views/custom/custom_app_bar.dart';
import 'package:mio_amore/views/custom/custom_headline.dart';
import 'package:mio_amore/views/custom/custom_icon_button.dart';
import 'package:mio_amore/views/others/user_image_card.dart';
import 'package:mio_amore/views/tabs/home/home_page.dart';
import 'package:mio_amore/views/tabs/home/notification_page.dart';

class FavouritesPage extends ConsumerWidget {
  const FavouritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final _matchedUsersProvider = ref.watch(matchStreamProvider);
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
              trailing: const NotificationButton(),
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
                  return _matchedUsersProvider.when(
                      data: (matches) {
                        final List<MatchedUsersView> _matchedViews = [];

                        for (final user in data) {
                          if (matches.any(
                              (element) => element.userIds.contains(user.id))) {
                            _matchedViews.add(MatchedUsersView(
                                user: user,
                                matchId: matches
                                    .firstWhere((element) =>
                                        element.userIds.contains(user.id))
                                    .id));
                          }
                        }
                        if (_matchedViews.isEmpty) {
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
                            children: _matchedViews.map((match) {
                              return UserImageCard(
                                  user: match.user, matchId: match.matchId);
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

class MatchedUsersView {
  UserProfileModel user;
  String matchId;
  MatchedUsersView({
    required this.user,
    required this.matchId,
  });

  MatchedUsersView copyWith({
    UserProfileModel? user,
    String? matchId,
  }) {
    return MatchedUsersView(
      user: user ?? this.user,
      matchId: matchId ?? this.matchId,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'user': user.toMap()});
    result.addAll({'matchId': matchId});

    return result;
  }

  factory MatchedUsersView.fromMap(Map<String, dynamic> map) {
    return MatchedUsersView(
      user: UserProfileModel.fromMap(map['user']),
      matchId: map['matchId'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory MatchedUsersView.fromJson(String source) =>
      MatchedUsersView.fromMap(json.decode(source));

  @override
  String toString() => 'MatchedUsersView(user: $user, matchId: $matchId)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MatchedUsersView &&
        other.user == user &&
        other.matchId == matchId;
  }

  @override
  int get hashCode => user.hashCode ^ matchId.hashCode;
}
