import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mio_amore/config/config.dart';
import 'package:http/http.dart' as http;
import 'package:mio_amore/helpers/constants.dart';
import 'package:mio_amore/helpers/get_location_prediction.dart';
import 'package:mio_amore/models/prediction_model.dart';
import 'package:mio_amore/models/user_account_settings_model.dart';
import 'package:mio_amore/providers/country_codes_provider.dart';
import 'package:mio_amore/providers/get_current_location_provider.dart';
import 'package:mio_amore/views/others/error_page.dart';
import 'package:mio_amore/views/others/loading_page.dart';

class SetUserLocation extends ConsumerStatefulWidget {
  const SetUserLocation({Key? key}) : super(key: key);

  @override
  ConsumerState<SetUserLocation> createState() => _SetUserLocationState();
}

class _SetUserLocationState extends ConsumerState<SetUserLocation> {
  final _searchController = TextEditingController();

  final List<Prediction> _predictions = [];

  @override
  void initState() {
    _searchController.addListener(() async {
      if (_searchController.text.isNotEmpty &&
          _searchController.text.length > 2) {
        final _results =
            await getLocationPrediction(_searchController.text.trim());
        if (_results != null) {
          setState(() {
            _predictions.clear();
            _predictions.addAll(_results);
          });
        }
      } else {
        _predictions.clear();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _currentLocationProviderProvider =
        ref.watch(getCurrentLocationProviderProvider);

    final _countryCodesProvider = ref.watch(countryCodesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Set Location"),
      ),
      body: _countryCodesProvider.when(
          data: (data) {
            return _currentLocationProviderProvider.when(
                data: (location) {
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (location != null)
                          ListTile(
                            onTap: () {
                              Navigator.of(context).pop(location);
                            },
                            title: const Text("Current Location"),
                            subtitle: Text(location.addressText),
                            leading: const Icon(Icons.location_on),
                            minLeadingWidth: 0,
                          ),
                        if (location != null) const Divider(height: 0),
                        if (location != null)
                          Padding(
                            padding: const EdgeInsets.all(
                                AppConstants.defaultNumericValue),
                            child: Text(
                              "Or Find another location",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        if (location == null)
                          const SizedBox(
                              height: AppConstants.defaultNumericValue),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppConstants.defaultNumericValue),
                          child: TextField(
                            controller: _searchController,
                            decoration: const InputDecoration(
                              hintText: "Search for a location",
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(
                                      AppConstants.defaultNumericValue),
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (_predictions.isEmpty &&
                            _searchController.text.isNotEmpty)
                          const SizedBox(
                            height: 300,
                            child: Center(
                              child: Text("No results found"),
                            ),
                          ),
                        if (_predictions.isEmpty &&
                            _searchController.text.isEmpty)
                          const SizedBox(
                            height: 300,
                            child: Center(
                              child: Text("Find a location"),
                            ),
                          ),
                        ..._predictions.map(
                          (e) {
                            return e.description != null
                                ? Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListTile(
                                        onTap: () async {
                                          EasyLoading.show(
                                              status: "Please wait...");

                                          _LocationComponents? _location =
                                              await getLocationFromPlaceID(
                                                  e.placeId!);

                                          if (_location != null) {
                                            final _userLocation = UserLocation(
                                              addressText: e.description!,
                                              latitude: _location.lat,
                                              longitude: _location.long,
                                            );
                                            EasyLoading.dismiss();

                                            Navigator.of(context)
                                                .pop(_userLocation);
                                          } else {
                                            EasyLoading.dismiss();
                                            Navigator.of(context).pop();
                                          }
                                        },
                                        title: Text(e.description!),
                                      ),
                                      const Divider(height: 0),
                                    ],
                                  )
                                : const SizedBox();
                          },
                        ).toList()
                      ],
                    ),
                  );
                },
                error: (_, e) {
                  return const ErrorPage();
                },
                loading: () => const LoadingPage());
          },
          error: (_, e) {
            return const ErrorPage();
          },
          loading: () => const LoadingPage()),
    );
  }
}

Future<_LocationComponents?> getLocationFromPlaceID(String placeId) async {
  final _url = Uri.parse(
      "https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeId&key=${AppConfig.locationApiKey}");

  var response = await http.get(_url, headers: {"Accept": "application/json"});

  if (response.statusCode == 200) {
    var data = json.decode(response.body);

    if (data["status"] != "OK") {
      return null;
    } else {
      double? _lat = data["result"]["geometry"]["location"]["lat"];
      double? _long = data["result"]["geometry"]["location"]["lng"];

      if (_lat != null && _long != null) {
        return _LocationComponents(lat: _lat, long: _long);
      }
    }
  } else {
    return null;
  }
  return null;
}

class _LocationComponents {
  double lat;
  double long;
  _LocationComponents({
    required this.lat,
    required this.long,
  });
}
