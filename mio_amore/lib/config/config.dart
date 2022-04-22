import 'package:flutter/material.dart';
import 'package:mio_amore/helpers/get_color_from.hex.dart';

class AppConfig {
  AppConfig._();

// Primary Constants
  static const String appName = "Mio Amore";
  static HexColor primaryColor = HexColor("#EE2F50");

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
