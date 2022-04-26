import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mio_amore/config/config.dart';
import 'package:mio_amore/helpers/constants.dart';
import 'package:mio_amore/helpers/get_location_prediction.dart';
import 'package:mio_amore/models/country_code.dart';
import 'package:mio_amore/models/prediction_model.dart';
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
                  // final List<CountryCode> _countryCodes = [];
                  // _countryCodes.addAll(location != null
                  //     ? data
                  //         .where((element) =>
                  //             location.addressText.contains(element.name))
                  //         .toList()
                  //     : []);

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
                        ..._predictions.map(
                          (e) {
                            return e.description != null
                                ? Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListTile(
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
