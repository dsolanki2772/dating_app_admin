import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mio_amore/config/config.dart';
import 'package:mio_amore/helpers/constants.dart';
import 'package:mio_amore/providers/user_profile_provider.dart';
import 'package:mio_amore/views/custom/custom_button.dart';
import 'package:mio_amore/views/custom/custom_headline.dart';

class ErrorPage extends ConsumerWidget {
  const ErrorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultNumericValue * 2),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomHeadLine(
                  text: AppConfig.appName,
                  secondPartColor: AppConstants.primaryColor),
              const SizedBox(height: AppConstants.defaultNumericValue),
              Text(
                "Something went wrong!",
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(color: Colors.black87),
              ),
              const SizedBox(height: AppConstants.defaultNumericValue * 2),
              CustomButton(
                onPressed: () {
                  ref.refresh(userProfileStreamProvider);
                },
                text: "Try again",
                icon: Icons.sync,
              )
            ],
          ),
        ),
      ),
    );
  }
}
