import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mio_amore/config/config.dart';

class MyBannerAd extends StatefulWidget {
  const MyBannerAd({Key? key}) : super(key: key);

  @override
  State<MyBannerAd> createState() => _MyBannerAdState();
}

class _MyBannerAdState extends State<MyBannerAd> {
  late BannerAd myBanner;
  bool isLoaded = false;

  @override
  void initState() {
    BannerAdListener bannerAdListener = BannerAdListener(
      onAdLoaded: (ad) {
        setState(() {
          isLoaded = true;
        });
      },
    );

    myBanner = BannerAd(
      adUnitId:
          Platform.isAndroid ? AndroidAdUnits.bannerId : IOSAdUnits.bannerId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: bannerAdListener,
    );
    myBanner.load();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoaded
        ? Container(
            alignment: Alignment.center,
            child: AdWidget(ad: myBanner),
            width: myBanner.size.width.toDouble(),
            height: myBanner.size.height.toDouble(),
          )
        : const SizedBox();
  }
}
