import 'package:flutter/material.dart';
import 'package:mioamoreapp/helpers/get_color_from.hex.dart';

class AppConfig {
  AppConfig._();

// Primary Constants
  static const String appName =
      "mio amore"; //!!App Name. Change this to your app name
  static HexColor primaryColor = HexColor("#EC1E79"); //!! App Primary Color

// Chat Constants
  static const String defaultChatBg =
      "assets/images/chat_bg.png"; //!! Default Chat Background. Change the image in assets/images/chat_bg.png. You can also change the image from the chat settings page.

  static const Color chatTextFieldAndOtherText = Color.fromARGB(
      255, 244, 238, 238); //!! Chat Text Field and Other user Text Color
  static const Color chatMyTextColor =
      Color.fromARGB(255, 255, 193, 202); //!! My text color

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
  ]; //!! Solid Colors for Chat Background. You can add more colors here or remove colors from here.

// User Interaction Buttons Settings

  static const Color dislikeButtonColor =
      Color.fromARGB(255, 246, 40, 25); //!! Dislike Button Color
  static const Color superLikeButtonColor =
      Color.fromARGB(255, 40, 205, 251); //!! Super Like Button Color
  static const Color likeButtonColor =
      Color.fromARGB(255, 120, 243, 124); //!! Like Button Color

  static const bool showInteractionButtonText =
      true; //!! Show Interaction Button Text
  static const String likeButtonText = "Like"; //!! Like Button Text
  static const String superLikeButtonText =
      "Super Like"; //!! Super Like Button Text
  static const String dislikeButtonText = "Dislike"; //!! Dislike Button Text

// Gender Settings

  static const bool allowTransGender =
      true; //!! Change this to False if you don't want transgender
  static const String maleText = "male"; //!! Male gender text
  static const String femaleText = "female"; //!! Female Gender text
  static const String transText = "other"; //!! Other Gender text

// Location Settings
  static const String locationApiKey =
      "AIzaSyDvkwrf9abC92F6SFdYEDmmYIgdvBrLi9o"; //!! Create this place api key from google cloud platform and paste here!
  //!! Link: https://!console.cloud.google.com/apis/credentials

// Base settings for a user!
  static const double initialDistanceInKM =
      100; //!! Initial Distance in KM to filter users
  static const double initialMaximumDistanceInKM =
      500; //!! Initial Maximum Distance in KM to filter users

  static const int maximumUserAge = 99; //!! Maximum default age to filter users

// Other Settings
  static const bool canChangeName = true; //!! Can user change name?
  static const bool userProfileShowWithoutImages =
      true; //!! Can user see other user profile without images?

  static const int minimumAgeRequired =
      18; //!! Minimum age required to use the app
  static const int maxNumOfMedia =
      6; //!! Maximum number of media a user can upload
  static const int maxNumOfInterests =
      5; //!! Maximum number of interests a user can select

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
  ]; //!! Interests List for user to select! You can add more or remove some!
}

// Authentication Modes
const bool isGoogleAuthAvailable = true; //!! Enable Google Authentication
const bool isFacebookAuthAvailable = true; //!! Enable Facebook Authentication
const bool isPhoneAuthAvailable = true; //!! Enable Phone Authentication
// const bool isAppleAuthAvailable = false;
// const bool isTwitterAuthAvailable = false;

// Company Pages Setup

// Must Have These Two
const String termsAndConditionsUrl =
    "https://incevio.com/page/terms-of-use"; //!! Terms and Conditions Page. You should use your own page or use this one.
const String privacyPolicyUrl =
    "https://incevio.com/page/privacy-policy"; //!! Privacy Policy Page. You should use your own page or use this one.

//These are optional
const bool isCompanyHasFAQ =
    true; //!! If you have FAQ page, set this to true and set the url below
const bool isCompanyHasAbout =
    true; //! If you have About page, set this to true and set the url below
const bool isCompanyHasContact =
    true; //! If you have Contact page, set this to true and set the url below

const String faqUrl = "https://incevio.com/faqs"; //! FAQ Page URL
const String contactUsUrl = "https://incevio.com/contact"; //! Contact Page URL
const String aboutUsUrl =
    "https://incevio.com/page/about-us"; //! About Page URL

// Ads Config
const bool isAdmobAvailable =
    true; //! Enable Admob Ads or not. If you don't want ads, set this to false. If you want ads, set this to true and set the ad ids below.

class AndroidAdUnits {
  AndroidAdUnits._();
  static const String appId =
      "ca-app-pub-3940256099942544~3347511713"; //! Admob Android App Id
  static const String bannerId =
      "ca-app-pub-3940256099942544/6300978111"; //! Admob Android Banner Ad Id
  static const String interstitialId =
      "ca-app-pub-3940256099942544/1033173712"; //! Admob Android Interstitial Ad Id
  static const String rewardedVideoId =
      "ca-app-pub-3940256099942544/5224354917"; //! Admob Android Rewarded Video Ad Id
}

class IOSAdUnits {
  IOSAdUnits._();
  static const String appId =
      "ca-app-pub-3940256099942544~1458002511"; //! Admob iOS App Id
  static const String bannerId =
      "ca-app-pub-3940256099942544/2934735716"; //! Admob iOS Banner Ad Id
  static const String interstitialId =
      "ca-app-pub-3940256099942544/4411468910"; //! Admob iOS Interstitial Ad Id
  static const String rewardedVideoId =
      "ca-app-pub-3940256099942544/1712485313"; //! Admob iOS Rewarded Video Ad Id
}
