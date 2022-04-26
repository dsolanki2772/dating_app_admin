import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mio_amore/config/config.dart';
import 'package:mio_amore/helpers/constants.dart';
import 'package:mio_amore/models/country_code.dart';
import 'package:mio_amore/providers/auth_providers.dart';
import 'package:mio_amore/providers/country_codes_provider.dart';
import 'package:mio_amore/providers/get_current_location_provider.dart';
import 'package:mio_amore/views/auth/login_with_phone_page.dart';
import 'package:mio_amore/views/auth/select_country_page.dart';
import 'package:mio_amore/views/custom/custom_button.dart';
import 'package:mio_amore/views/custom/custom_headline.dart';
import 'package:mio_amore/views/others/error_page.dart';
import 'package:mio_amore/views/others/loading_page.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppConstants.defaultGradient),
        padding: const EdgeInsets.all(AppConstants.defaultNumericValue * 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Expanded(
              child: Center(
                child: CustomHeadLine(
                    text: AppConfig.appName, secondPartColor: Colors.white),
              ),
            ),
            const SizedBox(height: AppConstants.defaultNumericValue),
            LoginButton(
              icon: Image.asset(googleLogo,
                  width: AppConstants.defaultNumericValue * 2),
              onPressed: () async {
                EasyLoading.show(status: 'Logging in...');
                await ref.read(authProvider).signInWithGoogle();
                EasyLoading.dismiss();
              },
              text: "Log in with google",
            ),
            const SizedBox(height: AppConstants.defaultNumericValue),
            LoginButton(
              icon: Image.asset(facebookLogo,
                  width: AppConstants.defaultNumericValue * 2),
              onPressed: () {
                EasyLoading.showInfo('Coming soon...');
              },
              text: "Log in with facebook",
            ),
            const SizedBox(height: AppConstants.defaultNumericValue),
            LoginButton(
              icon: Image.asset(twitterLogo,
                  width: AppConstants.defaultNumericValue * 2),
              onPressed: () {
                EasyLoading.showInfo('Coming soon...');
              },
              text: "Log in with twitter",
            ),
            if (Platform.isIOS)
              const SizedBox(height: AppConstants.defaultNumericValue),
            if (Platform.isIOS)
              LoginButton(
                icon: Image.asset(appleLogo,
                    width: AppConstants.defaultNumericValue * 2),
                onPressed: () {
                  EasyLoading.showInfo('Coming soon...');
                },
                text: "Log in with apple",
              ),
            const SizedBox(height: AppConstants.defaultNumericValue),
            LoginButton(
              icon: Icon(
                CupertinoIcons.phone_circle_fill,
                color: AppConstants.primaryColor,
                size: AppConstants.defaultNumericValue * 2,
              ),
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PhoneLoginLandingWidget(),
                  ),
                );
              },
              text: "Log in with phone",
            ),
            const SizedBox(height: AppConstants.defaultNumericValue),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.defaultNumericValue * 2),
              child: Text(
                "By logging in you agree to our Terms of Service and Privacy Policy.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.subtitle2!.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
            const SizedBox(height: AppConstants.defaultNumericValue),
            TextButton(
              onPressed: () {},
              child: const Text(
                "Trouble logging in?",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: AppConstants.defaultNumericValue),
          ],
        ),
      ),
    );
  }
}

class PhoneLoginLandingWidget extends ConsumerWidget {
  const PhoneLoginLandingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _countryCodesProvider = ref.watch(countryCodesProvider);
    final _currentLocationProviderProvider =
        ref.watch(getCurrentLocationProviderProvider);

    return _countryCodesProvider.when(
        data: (data) {
          return _currentLocationProviderProvider.when(
              data: (location) {
                if (location != null) {
                  final List<CountryCode> _countryCodes = data
                      .where((element) =>
                          location.addressText.contains(element.name))
                      .toList();

                  return _countryCodes.isEmpty
                      ? const SelectCountryPage()
                      : LoginWithPhoneNumberPage(
                          countryCode: _countryCodes.first);
                } else {
                  return const SelectCountryPage();
                }
              },
              error: (_, e) {
                return const ErrorPage();
              },
              loading: () => const LoadingPage());
        },
        error: (_, e) {
          return const ErrorPage();
        },
        loading: () => const LoadingPage());
  }
}

class LoginButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget icon;
  final String text;
  const LoginButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onPressed: onPressed,
      isWhite: true,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          icon,
          Text(
            text.toUpperCase(),
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: AppConstants.defaultNumericValue),
        ],
      ),
    );
  }
}
