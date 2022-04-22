import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mio_amore/config/config.dart';
import 'package:mio_amore/helpers/config_loading.dart';
import 'package:mio_amore/helpers/constants.dart';
import 'package:mio_amore/providers/auth_providers.dart';
import 'package:mio_amore/views/auth/login_page.dart';
import 'package:mio_amore/views/others/error_page.dart';
import 'package:mio_amore/views/others/loading_page.dart';
import 'package:mio_amore/views/tabs/bottom_nav_bar_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await Hive.initFlutter();
  await Hive.openBox(HiveConstants.hiveBox);

  configLoading();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      home: const LandingWidget(),
    );
  }
}

class LandingWidget extends ConsumerWidget {
  const LandingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _authStateProvider = ref.watch(authStateProvider);

    return _authStateProvider.when(
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
