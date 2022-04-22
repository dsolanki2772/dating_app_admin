import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mio_amore/helpers/constants.dart';
import 'package:mio_amore/models/user_profile_model.dart';
import 'package:mio_amore/views/others/user_details_page.dart';

class UserImageCard extends StatelessWidget {
  final bool isFavorite;
  final UserProfileModel user;
  const UserImageCard({
    Key? key,
    this.isFavorite = false,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => UserDetailsPage(user: user)));
      },
      child: GridTile(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(AppConstants.defaultNumericValue),
          ),
          child: ClipRRect(
            borderRadius:
                BorderRadius.circular(AppConstants.defaultNumericValue),
            child: (user.mediaFiles.isEmpty)
                ? const Center(
                    child: Icon(CupertinoIcons.photo),
                  )
                : CachedNetworkImage(
                    imageUrl:
                        user.mediaFiles.isNotEmpty ? user.mediaFiles.first : '',
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const Center(child: CupertinoActivityIndicator()),
                    errorWidget: (context, url, error) {
                      return const Center(child: Icon(CupertinoIcons.photo));
                    }),
          ),
        ),
        footer: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppConstants.defaultNumericValue / 2,
            horizontal: AppConstants.defaultNumericValue,
          ),
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.all(AppConstants.defaultNumericValue / 2),
                decoration: BoxDecoration(
                  //Gradient Frosted Box
                  borderRadius: BorderRadius.circular(
                      AppConstants.defaultNumericValue / 2),
                  color: Colors.black38,
                ),
                child: Center(
                  child: Text(
                    user.fullName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        header: isFavorite
            ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(CupertinoIcons.heart_solid,
                        color: CupertinoColors.destructiveRed,
                        size: AppConstants.defaultNumericValue * 1.5),
                  ),
                ],
              )
            : null,
      ),
    );
  }
}
