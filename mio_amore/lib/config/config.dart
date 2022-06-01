import 'package:flutter/material.dart';
import 'package:mio_amore/helpers/get_color_from.hex.dart';

class AppConfig {
  AppConfig._();

// Primary Constants
  static const String appName = "mio amore";
  static HexColor primaryColor = HexColor("#EC1E79");

// Chat Constants
  static const String defaultChatBg = "assets/images/chat_bg.png";
  static const Color chatTextFieldAndOtherText =
      Color.fromARGB(255, 244, 238, 238);
  static const Color chatMyTextColor = Color.fromARGB(255, 255, 193, 202);

  static const List<Color> wallpaperSolidColors = [
    Colors.deepPurple,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.indigo,
    Colors.cyan,
    Colors.teal,
    Colors.lime,
    Colors.lightGreen,
    Colors.lightBlue,
    Colors.lightBlueAccent,
    Colors.deepOrange,
    Colors.deepOrangeAccent,
    Colors.brown,
    Colors.grey,
    Colors.white,
  ];

// Gender Settings

  static const bool allowTransGender = false;
  static const String maleText = "male";
  static const String femaleText = "female";
  static const String transText = "other";

// Location Settings
  static const String locationApiKey =
      "AIzaSyDvkwrf9abC92F6SFdYEDmmYIgdvBrLi9o";

// Base settings for a user!
  static const double initialDistanceInKM = 50;
  static const double initialMaximumDistanceInKM = 500;
  static const int initialMinimumAge = 18;
  static const int initialMaximumAge = 28;

// Other Settings
  static const bool canChangeName = true;
  static const int minimumAgeRequired = 12;
  static const int maxNumOfMedia = 6;
  static const int maxNumOfInterests = 5;
  static const List<String> interests = [
    "pets",
    "exercise",
    "dancing",
    "cooking",
    "politics",
    "sports",
    "photography",
    "art",
    "learning",
    "music",
    "movies",
    "books",
    "gaming",
    "food",
    "fashion",
    "technology",
    "science",
    "health",
    "business",
  ];
}

// Authentication Modes
const bool isGoogleAuthAvailable = true;
const bool isFacebookAuthAvailable = true;
const bool isPhoneAuthAvailable = true;
const bool isAppleAuthAvailable = true;
const bool isTwitterAuthAvailable = true;

// Ads Config
const bool isAdmobAvailable = true;

class AndroidAdUnits {
  AndroidAdUnits._();
  static const String appId = "ca-app-pub-3940256099942544~3347511713";
  static const String bannerId = "ca-app-pub-3940256099942544/6300978111";
  static const String interstitialId = "ca-app-pub-3940256099942544/1033173712";
  static const String rewardedVideoId =
      "ca-app-pub-3940256099942544/5224354917";
}

class IOSAdUnits {
  IOSAdUnits._();
  static const String appId = "ca-app-pub-3940256099942544~1458002511";
  static const String bannerId = "ca-app-pub-3940256099942544/2934735716";
  static const String interstitialId = "ca-app-pub-3940256099942544/4411468910";
  static const String rewardedVideoId =
      "ca-app-pub-3940256099942544/1712485313";
}
