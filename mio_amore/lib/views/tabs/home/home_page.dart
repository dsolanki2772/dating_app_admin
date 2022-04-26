import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mio_amore/helpers/constants.dart';
import 'package:mio_amore/providers/user_profile_provider.dart';
import 'package:mio_amore/views/custom/custom_app_bar.dart';
import 'package:mio_amore/views/custom/custom_icon_button.dart';
import 'package:mio_amore/views/tabs/home/app_drawer.dart';

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
                                //TODO: Open Location!!
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
                                              ?.addressText ??
                                          "",
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
          ],
        ),
      ),
    );
  }
}
