import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mio_amore/helpers/constants.dart';
import 'package:mio_amore/helpers/date_formater.dart';
import 'package:mio_amore/models/feed_model.dart';
import 'package:mio_amore/models/user_profile_model.dart';
import 'package:mio_amore/providers/feed_provider.dart';
import 'package:mio_amore/providers/other_users_provider.dart';
import 'package:mio_amore/providers/user_profile_provider.dart';
import 'package:mio_amore/views/custom/custom_app_bar.dart';
import 'package:mio_amore/views/custom/custom_headline.dart';
import 'package:mio_amore/views/custom/custom_icon_button.dart';
import 'package:mio_amore/views/others/photo_view_page.dart';
import 'package:mio_amore/views/tabs/feeds/feed_post_page.dart';
import 'package:mio_amore/views/tabs/home/notification_page.dart';

class FeedsPage extends ConsumerWidget {
  const FeedsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
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
              leading:
                  const SizedBox(width: AppConstants.defaultNumericValue * 2),
              title: Center(
                  child: CustomHeadLine(
                text: 'Feeds',
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
          const Expanded(child: FeedsBody()),
        ],
      ),
    );
  }
}

class FeedsBody extends ConsumerStatefulWidget {
  const FeedsBody({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FeedsBodyState();
}

class _FeedsBodyState extends ConsumerState<FeedsBody> {
  @override
  Widget build(BuildContext context) {
    final _feedList = ref.watch(getFeedsProvider);
    return ListView(
      children: [
        const CreateNewPostSection(),
        ..._feedList.when(
            data: (data) {
              final _otherUsersProvider = ref.watch(otherUsersProvider);
              final _userProfileProvider = ref.watch(userProfileStreamProvider);

              List<UserProfileModel> _feedsUsers = [];

              _otherUsersProvider.whenData((value) {
                final _users = value.where((element) {
                  return data
                      .map((e) => e.userId)
                      .toList()
                      .contains(element.userId);
                }).toList();

                _feedsUsers.addAll(_users);
              });

              _userProfileProvider.whenData((value) {
                _feedsUsers.add(value!);
              });

              return data.isEmpty
                  ? [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: const Center(child: Text('No Feeds Yet')))
                    ]
                  : data.map((e) {
                      final _user = _feedsUsers
                          .firstWhere((element) => element.userId == e.userId);
                      return SingleFeedPost(feed: e, user: _user);
                    });
            },
            error: (_, __) => [const SizedBox()],
            loading: () => [const SizedBox()]),
      ],
    );
  }
}

class CreateNewPostSection extends ConsumerWidget {
  const CreateNewPostSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final _currentUserProfile = ref.read(userProfileStreamProvider);

    return _currentUserProfile.when(
        data: (data) {
          return data == null
              ? const SizedBox()
              : Padding(
                  padding: const EdgeInsets.only(
                      top: 0, bottom: 8, left: 16, right: 16),
                  child: Row(
                    children: [
                      UserCirlePicture(
                          imageUrl: data.profilePicture,
                          size: AppConstants.defaultNumericValue * 2.5),
                      const SizedBox(width: 16),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => const FeedPostPage()),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1,
                                  color: Colors.black.withOpacity(0.87)),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Text("Share your thoughts",
                                style: Theme.of(context).textTheme.subtitle2),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
        },
        error: (_, __) => const SizedBox(),
        loading: () => const SizedBox());
  }
}

class SingleFeedPost extends ConsumerWidget {
  final FeedModel feed;
  final UserProfileModel user;
  const SingleFeedPost({
    Key? key,
    required this.feed,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              UserCirlePicture(
                  imageUrl: user.profilePicture,
                  size: AppConstants.defaultNumericValue * 2.5),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.fullName,
                        style: Theme.of(context).textTheme.subtitle1),
                    Text(
                      DateFormatter.toWholeDateTime(feed.createdAt),
                      textAlign: TextAlign.end,
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .copyWith(fontSize: 10),
                    ),
                  ],
                ),
              ),
              if (feed.userId == FirebaseAuth.instance.currentUser!.uid)
                GestureDetector(
                  onTap: () {},
                  child: const Icon(CupertinoIcons.ellipsis_vertical),
                ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          if (feed.caption != null) PostText(postText: feed.caption!),
          const SizedBox(
            height: 8,
          ),
          if (feed.images.isNotEmpty)
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PhotoViewPage(images: feed.images),
                  ),
                );
              },
              child: PostImages(post: feed),
            ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class PostText extends StatefulWidget {
  final String postText;
  const PostText({
    Key? key,
    required this.postText,
  }) : super(key: key);

  @override
  State<PostText> createState() => _PostTextState();
}

class _PostTextState extends State<PostText> {
  int _maxLInes = 3;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _maxLInes = _maxLInes > 3 ? 3 : 99999;
        });
      },
      child: Text(
        widget.postText,
        textAlign: TextAlign.start,
        maxLines: _maxLInes,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context)
            .textTheme
            .bodyText2!
            .copyWith(fontSize: 16, color: Colors.black.withOpacity(0.87)),
      ),
    );
  }
}

class PostImages extends StatelessWidget {
  final FeedModel post;
  const PostImages({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: post.images.length == 1
          ? PostSingleImage(imageUrl: post.images.first)
          : post.images.length == 2
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: PostSingleImage(imageUrl: post.images.first),
                    ),
                    Expanded(
                      child: PostSingleImage(imageUrl: post.images.last),
                    )
                  ],
                )
              : post.images.length == 3
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                  child: PostSingleImage(
                                imageUrl: post.images[0],
                              )),
                              Expanded(
                                child: PostSingleImage(
                                  imageUrl: post.images[1],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: PostSingleImage(
                            imageUrl: post.images.last,
                          ),
                        )
                      ],
                    )
                  : post.images.length == 4
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                      child: PostSingleImage(
                                    imageUrl: post.images[0],
                                  )),
                                  Expanded(
                                    child: PostSingleImage(
                                      imageUrl: post.images[1],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                      child: PostSingleImage(
                                    imageUrl: post.images[2],
                                  )),
                                  Expanded(
                                    child: PostSingleImage(
                                      imageUrl: post.images[3],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                      child: PostSingleImage(
                                    imageUrl: post.images[0],
                                  )),
                                  Expanded(
                                    child: PostSingleImage(
                                      imageUrl: post.images[1],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                      child: PostSingleImage(
                                    imageUrl: post.images[2],
                                  )),
                                  Expanded(
                                    child: PostSingleImage(
                                      moreNumberOfImages:
                                          "${post.images.length - 3}+",
                                      imageUrl: post.images[3],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
    );
  }
}

class PostSingleImage extends StatelessWidget {
  final String imageUrl;
  final String? moreNumberOfImages;
  const PostSingleImage({
    Key? key,
    required this.imageUrl,
    this.moreNumberOfImages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 2),
            image: moreNumberOfImages != null
                ? DecorationImage(image: NetworkImage(imageUrl))
                : null,
            color: Colors.white),
        child: moreNumberOfImages == null
            ? CachedNetworkImage(imageUrl: imageUrl, fit: BoxFit.cover)
            : Container(
                color: Colors.black.withOpacity(0.47),
                child: Center(
                  child: Text(
                    moreNumberOfImages!,
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(color: Colors.white),
                  ),
                ),
              ));
  }
}
