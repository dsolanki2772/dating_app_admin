import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mio_amore/config/config.dart';
import 'package:mio_amore/helpers/constants.dart';
import 'package:mio_amore/views/custom/custom_button.dart';

class AccountSettingsPage extends ConsumerStatefulWidget {
  const AccountSettingsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AccountSettingsPageState();
}

class _AccountSettingsPageState extends ConsumerState<AccountSettingsPage> {
  final _locationController = TextEditingController();
  double _distanceInKm = 5;
  final double _maxDistanceInKm = 100;
  double _minimumAge = 18;
  double _maximumAge = 28;
  String? _interestedIn;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultNumericValue),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // const SizedBox(height: AppConstants.defaultNumericValue),
            Text(
              'Location',
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppConstants.defaultNumericValue),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.defaultNumericValue,
                vertical: AppConstants.defaultNumericValue / 2,
              ),
              decoration: BoxDecoration(
                color: AppConstants.primaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(
                  AppConstants.defaultNumericValue,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: AppConstants.primaryColor,
                  ),
                  const SizedBox(width: AppConstants.defaultNumericValue / 2),
                  Expanded(
                    child: TextField(
                      controller: _locationController,
                      readOnly: true,
                      onTap: () {},
                      decoration: const InputDecoration(
                        hintText: 'Set your location',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppConstants.defaultNumericValue * 2),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Distance',
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: AppConstants.defaultNumericValue),
                Text(
                  '${_distanceInKm.toInt()} km',
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppConstants.primaryColor),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.defaultNumericValue),
            Slider(
              value: _distanceInKm,
              min: 1,
              max: _maxDistanceInKm,
              onChanged: (value) {
                setState(() {
                  _distanceInKm = value;
                });
              },
            ),
            const SizedBox(height: AppConstants.defaultNumericValue * 2),
            Text("Interested In",
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: AppConstants.defaultNumericValue),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: AppConstants.defaultNumericValue / 2,
              runSpacing: AppConstants.defaultNumericValue / 2,
              children: [
                _GenderButton(
                  text: AppConfig.maleText.toUpperCase(),
                  isSelected: _interestedIn == AppConfig.maleText,
                  onPressed: () {
                    setState(() {
                      _interestedIn = AppConfig.maleText;
                    });
                  },
                ),
                _GenderButton(
                  text: AppConfig.femaleText.toUpperCase(),
                  isSelected: _interestedIn == AppConfig.femaleText,
                  onPressed: () {
                    setState(() {
                      _interestedIn = AppConfig.femaleText;
                    });
                  },
                ),
                if (AppConfig.allowTransGender)
                  _GenderButton(
                    text: AppConfig.transText.toUpperCase(),
                    isSelected: _interestedIn == AppConfig.transText,
                    onPressed: () {
                      setState(() {
                        _interestedIn = AppConfig.transText;
                      });
                    },
                  ),
                _GenderButton(
                  text: AppConfig.allowTransGender
                      ? "all".toUpperCase()
                      : "both".toUpperCase(),
                  isSelected: _interestedIn == null,
                  onPressed: () {
                    setState(() {
                      _interestedIn = null;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: AppConstants.defaultNumericValue * 2),
            Row(
              children: [
                Expanded(
                  child: Text("Age Range",
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: AppConstants.defaultNumericValue),
                Text(
                  '${_minimumAge.toInt()} - ${_maximumAge.toInt()}',
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppConstants.primaryColor),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.defaultNumericValue),
            RangeSlider(
              values:
                  RangeValues(_minimumAge.toDouble(), _maximumAge.toDouble()),
              min: AppConfig.minimumAgeRequired.toDouble(),
              max: 70.0,
              onChanged: (RangeValues values) {
                setState(() {
                  _minimumAge = values.start;
                  _maximumAge = values.end;
                });
              },
            ),
            const SizedBox(height: AppConstants.defaultNumericValue * 2),
            CustomButton(
              onPressed: () {},
              text: 'Apply',
            ),
          ],
        ),
      ),
    );
  }
}

class _GenderButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final bool isSelected;
  const _GenderButton({
    Key? key,
    required this.onPressed,
    required this.text,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.defaultNumericValue * 1.5,
          vertical: AppConstants.defaultNumericValue,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppConstants.primaryColor
              : AppConstants.primaryColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(
            AppConstants.defaultNumericValue,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppConstants.primaryColor.withOpacity(0.2),
                    blurRadius: AppConstants.defaultNumericValue,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                color: isSelected ? Colors.white : Colors.black,
              ),
        ),
      ),
    );
  }
}
