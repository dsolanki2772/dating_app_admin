import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mio_amore/helpers/constants.dart';
import 'package:mio_amore/helpers/date_formater.dart';
import 'package:mio_amore/models/notification_model.dart';
import 'package:mio_amore/models/user_profile_model.dart';
import 'package:mio_amore/providers/notifiaction_provider.dart';
import 'package:mio_amore/providers/other_users_provider.dart';
import 'package:mio_amore/views/custom/custom_app_bar.dart';
import 'package:mio_amore/views/custom/custom_headline.dart';
import 'package:mio_amore/views/custom/custom_icon_button.dart';
import 'package:mio_amore/views/others/user_details_page.dart';
import 'package:mio_amore/views/tabs/home/home_page.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);
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
                  icon: CupertinoIcons.back,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  padding: const EdgeInsets.all(
                      AppConstants.defaultNumericValue / 1.5)),
              title: Center(
                  child: CustomHeadLine(
                text: 'Notifications',
                secondPartColor: AppConstants.primaryColor,
              )),
              trailing:
                  const SizedBox(width: AppConstants.defaultNumericValue * 2),
            ),
          ),
          const SizedBox(height: AppConstants.defaultNumericValue),
          const Expanded(child: NotificationBody()),
        ],
      ),
    );
  }
}

class NotificationBody extends ConsumerWidget {
  const NotificationBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void deleteNotification(NotificationModel item) {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: const EdgeInsets.all(AppConstants.defaultNumericValue),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                      'Are you sure you want to delete this notification?'),
                  const SizedBox(height: AppConstants.defaultNumericValue),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(width: AppConstants.defaultNumericValue),
                      TextButton(
                        child: const Text('Delete'),
                        onPressed: () {
                          Navigator.pop(context);
                          deleteNotification(item);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          });
    }

    void onTapNotification(WidgetRef ref, NotificationModel item) {
      if (item.isMatchingNotification) {
        final _otherUsersProvider = ref.read(otherUsersProvider);

        UserProfileModel? _otherUser;
        _otherUsersProvider.whenData((value) {
          _otherUser = value.firstWhere((element) => element.id == item.userId);
        });

        if (_otherUser != null) {
          if (!item.isRead) {
            updateNotification(item.copyWith(isRead: true));
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserDetailsPage(
                user: _otherUser!,
                matchId: item.matchId,
              ),
            ),
          );
        }
      }

      if (item.isInteractionNotification) {
        if (!item.isRead) {
          updateNotification(item.copyWith(isRead: true));
        }
        Navigator.pop(context);
      }
    }

    final _notifications = ref.watch(notificationsStreamProvider);
    return _notifications.when(
      data: (data) {
        if (data.isEmpty) {
          return const Center(child: Text('No notifications'));
        } else {
          return ListView.separated(
            itemBuilder: (context, index) {
              NotificationModel _item = data[index];

              return ListTile(
                onLongPress: () {
                  deleteNotification(_item);
                },
                onTap: () {
                  onTapNotification(ref, _item);
                },
                title: Text(_item.title),
                tileColor: _item.isRead
                    ? null
                    : AppConstants.primaryColor.withOpacity(0.2),
                subtitle: Text(_item.body),
                trailing: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      DateFormatter.toTime(_item.createdAt),
                      style: Theme.of(context).textTheme.caption,
                    ),
                    Text(
                      DateFormatter.toYearMonthDay2(_item.createdAt),
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
                leading: _item.image == null
                    ? CircleAvatar(
                        radius: AppConstants.defaultNumericValue * 1.5,
                        backgroundColor: AppConstants.primaryColor,
                        child: Text(
                          _item.title.substring(0, 1),
                          style: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(color: Colors.white),
                        ),
                      )
                    : UserCirlePicture(
                        imageUrl: _item.image,
                        size: AppConstants.defaultNumericValue * 2.5),
              );
            },
            itemCount: data.length,
            separatorBuilder: (context, index) => const Divider(height: 0),
          );
        }
      },
      error: (e, st) {
        return const SizedBox();
      },
      loading: () {
        return const SizedBox();
      },
    );
  }
}
