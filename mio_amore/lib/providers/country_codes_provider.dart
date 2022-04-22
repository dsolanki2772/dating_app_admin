import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mio_amore/helpers/constants.dart';
import 'package:mio_amore/models/country_code.dart';

final countryCodesProvider = FutureProvider<List<CountryCode>>((ref) async {
  final _response = await rootBundle.loadString(countryCodeJson);
  return countryCodeFromJson(_response);
});
