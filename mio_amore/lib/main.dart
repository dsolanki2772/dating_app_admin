// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mio_amore/config/config.dart';
import 'package:mio_amore/helpers/config_loading.dart';
import 'package:mio_amore/helpers/constants.dart';
import 'package:mio_amore/providers/auth_providers.dart';
import 'package:mio_amore/views/auth/login_page.dart';
import 'package:mio_amore/views/others/error_page.dart';
import 'package:mio_amore/views/others/loading_page.dart';
import 'package:mio_amore/views/tabs/bottom_nav_bar_page.dart';
import 'package:mio_amore/views/tabs/home/notification_page.dart';
import 'package:mio_amore/views/tabs/messages/components/chat_page.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp();
  await MobileAds.instance.initialize();

  FirebaseMessaging.onBackgroundMessage(_handleBackgroundNotification);

  await Hive.initFlutter();
  await Hive.openBox(HiveConstants.hiveBox);
  configLoading();

// // Awesome Notifications Setup
//   await AwesomeNotifications().initialize(
//     null,
//     [
//       NotificationChannel(
//           channelKey: 'basic_notification',
//           channelName: 'Basic notifications',
//           channelDescription: 'All Notifications',
//           defaultColor: AppConstants.primaryColor,
//           ledColor: Colors.white)
//     ],
//   );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return MaterialApp(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
      theme: ThemeData(
        primarySwatch: _primarySwatch,
        textTheme: GoogleFonts.varelaRoundTextTheme(
          Theme.of(context).textTheme,
        ),
        appBarTheme: AppBarTheme(
            elevation: 0,
            centerTitle: true,
            backgroundColor: AppConstants.primaryColor),
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () {
      FlutterNativeSplash.remove();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LandingWidget(),
        ),
      );
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: LoadingPage());
  }
}

class LandingWidget extends ConsumerStatefulWidget {
  const LandingWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<LandingWidget> createState() => _LandingWidgetState();
}

class _LandingWidgetState extends ConsumerState<LandingWidget> {
  @override
  void initState() {
    _setupInteractedMessage();
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      showAwesomeNotification(message);
    });
    FirebaseMessaging.onMessage.listen((message) {
      showAwesomeNotification(message);
    });
    super.initState();
  }

  Future<void> _setupInteractedMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    if (message.data['type'] == 'message') {
      final otherUserId = message.data["userId"]!;
      final matchId = message.data["matchId"]!;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ChatPage(matchId: matchId, otherUserId: otherUserId),
        ),
      );
    } else if (message.data['type'] == 'notification') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const NotificationPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
        data: (data) {
          if (data != null) {
            return const BottomNavBarPage();
          } else {
            return const LoginPage();
          }
        },
        error: (_, e) {
          return const ErrorPage();
        },
        loading: () => const LoadingPage());
  }
}

final _primarySwatch = MaterialColor(AppConstants.primaryColor.value, _swatch);
final _swatch = {
  50: AppConstants.primaryColor.withOpacity(0.1),
  100: AppConstants.primaryColor.withOpacity(0.2),
  200: AppConstants.primaryColor.withOpacity(0.3),
  300: AppConstants.primaryColor.withOpacity(0.4),
  400: AppConstants.primaryColor.withOpacity(0.5),
  500: AppConstants.primaryColor.withOpacity(0.6),
  600: AppConstants.primaryColor.withOpacity(0.7),
  700: AppConstants.primaryColor.withOpacity(0.8),
  800: AppConstants.primaryColor.withOpacity(0.9),
  900: AppConstants.primaryColor.withOpacity(1),
};

Future<void> _handleBackgroundNotification(RemoteMessage message) async {
  await Firebase.initializeApp();
  showAwesomeNotification(message);
}

void showAwesomeNotification(RemoteMessage message) {
  // if (!AwesomeStringUtils.isNullOrEmpty(message.notification?.title,
  //         considerWhiteSpaceAsEmpty: true) ||
  //     !AwesomeStringUtils.isNullOrEmpty(message.notification?.body,
  //         considerWhiteSpaceAsEmpty: true)) {
  //   String? imageUrl;
  //   imageUrl ??= message.notification!.android?.imageUrl;
  //   imageUrl ??= message.notification!.apple?.imageUrl;

  //   Map<String, dynamic> notificationAdapter = {
  //     NOTIFICATION_CHANNEL_KEY: 'basic_notification',
  //     NOTIFICATION_ID: message.data[NOTIFICATION_CONTENT]?[NOTIFICATION_ID] ??
  //         message.messageId ??
  //         Random().nextInt(2147483647),
  //     NOTIFICATION_TITLE: message.data[NOTIFICATION_CONTENT]
  //             ?[NOTIFICATION_TITLE] ??
  //         message.notification?.title,
  //     NOTIFICATION_BODY: message.data[NOTIFICATION_CONTENT]
  //             ?[NOTIFICATION_BODY] ??
  //         message.notification?.body,
  //     NOTIFICATION_LAYOUT:
  //         AwesomeStringUtils.isNullOrEmpty(imageUrl) ? 'Default' : 'BigPicture',
  //     NOTIFICATION_BIG_PICTURE: imageUrl
  //   };

  //   AwesomeNotifications().createNotificationFromJsonData(notificationAdapter);
  // } else {
  //   AwesomeNotifications().createNotificationFromJsonData(message.data);
  // }

  print("Notification type: ${message.data["type"]}");
  print("Other User Id ${message.data["userId"]}");
  print("MatchId ${message.data["matchId"]}");
}
