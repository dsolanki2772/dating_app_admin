import 'package:flutter/material.dart';
import 'package:mio_amore/config/config.dart';
import 'package:mio_amore/helpers/constants.dart';
import 'package:mio_amore/views/custom/custom_headline.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              const SizedBox(height: AppConstants.defaultNumericValue * 2),
              CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppConstants.primaryColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
