import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mio_amore/config/config.dart';
import 'package:mio_amore/models/location_result_model.dart';
import 'package:mio_amore/models/user_account_settings_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

String getLocationApiString(double lat, double long) {
  return "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$long&key=${AppConfig.locationApiKey}";
}

final getCurrentLocationProviderProvider =
    FutureProvider<UserLocation?>((ref) async {
  try {
    final Position _position = await _determineCurrentPosition();

    final _api = Uri.parse(
        getLocationApiString(_position.latitude, _position.longitude));

    final _response = await http.get(_api);

    if (_response.statusCode == 200) {
      final LocationResultModel _resultModel =
          LocationResultModel.fromJson(_response.body);

      if (_resultModel.status == "OK" && _resultModel.results.isNotEmpty) {
        final Result _addressResult = _resultModel.results.first;

        String? _country;
        String? _administrativeAreaLevel1;
        String? _administrativeAreaLevel2;

        if (_addressResult.addressComponents != null) {
          for (var component in _addressResult.addressComponents!) {
            if (component.types.contains("country")) {
              _country = component.longName;
            } else if (component.types
                .contains("administrative_area_level_1")) {
              _administrativeAreaLevel1 = component.longName;
            } else if (component.types
                .contains("administrative_area_level_2")) {
              _administrativeAreaLevel2 = component.longName;
            }
          }

          final String _formattedAddress = getFormattedAddress(
              _country, _administrativeAreaLevel1, _administrativeAreaLevel2);

          final UserLocation _userLocation = UserLocation(
              latitude: _position.latitude,
              longitude: _position.longitude,
              addressText: _formattedAddress);

          debugPrint(_formattedAddress);

          return _userLocation;
        }
        return null;
      } else {
        return null;
      }
    } else {
      return null;
    }
  } catch (e) {
    EasyLoading.showToast(e.toString(),
        duration: const Duration(seconds: 3),
        toastPosition: EasyLoadingToastPosition.bottom);
    return null;
  }
});

Future<Position> _determineCurrentPosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low);
}

String getFormattedAddress(String? country, String? administrativeAreaLevel1,
    String? administrativeAreaLevel2) {
  String _formattedAddress = "";

  if (administrativeAreaLevel2 != null) {
    _formattedAddress += administrativeAreaLevel2 + ", ";
  }
  if (administrativeAreaLevel1 != null) {
    _formattedAddress += administrativeAreaLevel1 + ", ";
  }
  if (country != null) {
    _formattedAddress += country;
  }

  return _formattedAddress;
}
