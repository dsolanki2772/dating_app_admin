import 'package:flutter/material.dart';
import 'package:mio_amore/config/config.dart';

class AppConstants {
  AppConstants._();

  static Color primaryColor = AppConfig.primaryColor;
  static const double defaultNumericValue = 16.0;

  static LinearGradient defaultGradient = LinearGradient(
    colors: [
      AppConstants.primaryColor.withOpacity(0.8),
      AppConstants.primaryColor,
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

class FirebaseConstants {
  FirebaseConstants._();

  static const String userProfileCollection = "userProfile";
  static const String userInteractionCollection = "userInteraction";
  static const String matchCollection = "matches";
  static const verificationFormsCollection = "verificationForms";
}

class HiveConstants {
  HiveConstants._();

  static const String hiveBox = "hiveBox";

  static const String chatWallpaper = "chatWallpaper";
}

const String countryCodeJson = "assets/json/country_code.json";
const String appleLogo = "assets/logos/apple.png";
const String facebookLogo = "assets/logos/facebook.png";
const String googleLogo = "assets/logos/google.png";
const String twitterLogo = "assets/logos/twitter.png";

const String defaultImage =
    "https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80";
const String profilePicture =
    "https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80";

final emailVerificationRedExp = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
