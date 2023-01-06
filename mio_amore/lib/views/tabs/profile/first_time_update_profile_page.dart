import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mio_amore/config/config.dart';
import 'package:mio_amore/helpers/constants.dart';
import 'package:mio_amore/models/user_account_settings_model.dart';
import 'package:mio_amore/models/user_profile_model.dart';
import 'package:mio_amore/providers/auth_providers.dart';
import 'package:mio_amore/providers/user_profile_provider.dart';
import 'package:mio_amore/views/custom/custom_button.dart';
import 'package:mio_amore/views/others/set_user_location_page.dart';

class FirstTimeUserProfilePage extends ConsumerStatefulWidget {
  const FirstTimeUserProfilePage({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<FirstTimeUserProfilePage> createState() =>
      _FirstTimeUserProfilePageState();
}

class _FirstTimeUserProfilePageState
    extends ConsumerState<FirstTimeUserProfilePage> {
  final _pageController = PageController();
  int _currentPage = 0;
  final _totalPages = 2;

  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();

  String? _gender;

  final _birthdayController = TextEditingController();
  DateTime? _birthday;

  UserLocation? _userLocation;

  final List<String> _interests = [];

  @override
  void initState() {
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
    super.initState();
  }

  void _onSubmit() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    final UserAccountSettingsModel userAccountSettingsModel =
        UserAccountSettingsModel(
      location: _userLocation!,
      maximumAge: AppConfig.maximumUserAge,
      minimumAge: AppConfig.minimumAgeRequired,
    );

    final UserProfileModel userProfileModel = UserProfileModel(
      id: userId,
      userId: userId,
      fullName: _fullNameController.text.trim(),
      mediaFiles: [],
      interests: _interests,
      gender: _gender!,
      birthDay: _birthday!,
      email: FirebaseAuth.instance.currentUser!.email,
      phoneNumber: FirebaseAuth.instance.currentUser!.phoneNumber,
      userAccountSettingsModel: userAccountSettingsModel,
      isVerified: false,
    );
    final result =
        await ref.read(userProfileProvider).createUserProfile(userProfileModel);
    if (result) {
      ref.invalidate(isUserAddedProvider);
      ref.invalidate(userProfileFutureProvider);
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Form(
        key: _formKey,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            foregroundColor: Colors.black,
            leading: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Are you sure you want to cancel?"),
                    content: const Text("You will be logged out."),
                    actions: [
                      TextButton(
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: const Text(
                          "Sure",
                          style: TextStyle(color: Colors.red),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          ref.read(authProvider).signOut();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  for (var i = 0; i < _totalPages; i++)
                    Expanded(
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: _currentPage >= i
                              ? AppConstants.primaryColor
                              : Colors.grey[300],
                        ),
                      ),
                    )
                ],
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    UserDetailsTakingScreen(
                      nameController: _fullNameController,
                      onGenderSelected: (gender) {
                        setState(() {
                          _gender = gender;
                        });
                      },
                      gender: _gender,
                      birthday: _birthday,
                      onBirthdaySelected: (birthday) {
                        setState(() {
                          _birthday = birthday;
                        });
                      },
                      birthdayController: _birthdayController,
                      selectedInterests: _interests,
                      onSelectInterest: (notSelected, interest) {
                        setState(() {
                          if (notSelected) {
                            if (_interests.length >=
                                AppConfig.maxNumOfInterests) {
                              EasyLoading.showToast(
                                  "You can only select ${AppConfig.maxNumOfInterests} interests",
                                  toastPosition:
                                      EasyLoadingToastPosition.bottom);
                            } else {
                              _interests.add(interest);
                            }
                          } else {
                            _interests.remove(interest);
                          }
                        });
                      },
                      onNext: () {
                        if (_formKey.currentState!.validate()) {
                          if (_gender != null) {
                            if (_interests.isNotEmpty) {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              );
                            } else {
                              EasyLoading.showToast(
                                  "Please select at least one interest",
                                  toastPosition:
                                      EasyLoadingToastPosition.bottom);
                            }
                          } else {
                            EasyLoading.showToast(
                                "Please select your your gender",
                                toastPosition: EasyLoadingToastPosition.bottom);
                          }
                        }
                      },
                    ),
                    _UserLocationScreen(
                      onLocationChanged: (location) {
                        setState(() {
                          _userLocation = location;
                        });
                      },
                      location: _userLocation,
                      onNext: () {
                        if (_formKey.currentState!.validate()) {
                          if (_userLocation != null) {
                            _onSubmit();
                          } else {
                            EasyLoading.showInfo(
                                "Please set your location to continue.");
                          }
                        }
                      },
                      onBack: () {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserDetailsTakingScreen extends StatelessWidget {
  final TextEditingController nameController;
  final Function(String gender) onGenderSelected;
  final String? gender;
  final Function(DateTime birthday) onBirthdaySelected;
  final TextEditingController birthdayController;
  final DateTime? birthday;
  final List<String> selectedInterests;
  final Function(bool, String) onSelectInterest;
  final VoidCallback onNext;
  const UserDetailsTakingScreen({
    Key? key,
    required this.nameController,
    required this.onGenderSelected,
    this.gender,
    required this.onBirthdaySelected,
    required this.birthdayController,
    this.birthday,
    required this.selectedInterests,
    required this.onSelectInterest,
    required this.onNext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.defaultNumericValue * 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.defaultNumericValue),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Welcome to ${AppConfig.appName}",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline5!.copyWith(
                      color: AppConstants.primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppConstants.defaultNumericValue / 2),
                Text("Please fill in your details to continue.",
                    style: Theme.of(context).textTheme.caption!)
              ],
            ),
          ),
          const SizedBox(height: AppConstants.defaultNumericValue * 3),
          Text(
            "My name is",
            style: Theme.of(context)
                .textTheme
                .headline5!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppConstants.defaultNumericValue),
          TextFormField(
            controller: nameController,
            autofocus: true,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
            decoration: const InputDecoration(
              label: Text('Name'),
            ),
          ),
          const SizedBox(height: AppConstants.defaultNumericValue),
          Text(
            "Please enter your full name. You ${AppConfig.canChangeName ? "can" : "cannot"} change it later.",
            style: Theme.of(context)
                .textTheme
                .caption!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppConstants.defaultNumericValue * 2),
          Text(
            "I am",
            style: Theme.of(context)
                .textTheme
                .headline5!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppConstants.defaultNumericValue),
          Wrap(
            alignment: WrapAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  onGenderSelected(AppConfig.maleText);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppConstants.defaultNumericValue / 1.5,
                    horizontal: AppConstants.defaultNumericValue,
                  ),
                  decoration: BoxDecoration(
                    color: gender == AppConfig.maleText
                        ? AppConstants.primaryColor.withOpacity(0.4)
                        : null,
                    border:
                        Border.all(color: AppConstants.primaryColor, width: 2),
                    borderRadius: BorderRadius.circular(
                        AppConstants.defaultNumericValue * 2),
                  ),
                  child: Text(
                    AppConfig.maleText.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: AppConstants.defaultNumericValue),
              GestureDetector(
                onTap: () {
                  onGenderSelected(AppConfig.femaleText);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppConstants.defaultNumericValue / 1.5,
                    horizontal: AppConstants.defaultNumericValue,
                  ),
                  decoration: BoxDecoration(
                    color: gender == AppConfig.femaleText
                        ? AppConstants.primaryColor.withOpacity(0.4)
                        : null,
                    border:
                        Border.all(color: AppConstants.primaryColor, width: 2),
                    borderRadius: BorderRadius.circular(
                        AppConstants.defaultNumericValue * 2),
                  ),
                  child: Text(
                    AppConfig.femaleText.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              if (AppConfig.allowTransGender)
                const SizedBox(width: AppConstants.defaultNumericValue),
              if (AppConfig.allowTransGender)
                GestureDetector(
                  onTap: () {
                    onGenderSelected(AppConfig.transText);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppConstants.defaultNumericValue / 1.5,
                      horizontal: AppConstants.defaultNumericValue,
                    ),
                    decoration: BoxDecoration(
                      color: gender == AppConfig.transText
                          ? AppConstants.primaryColor.withOpacity(0.4)
                          : null,
                      border: Border.all(
                          color: AppConstants.primaryColor, width: 2),
                      borderRadius: BorderRadius.circular(
                          AppConstants.defaultNumericValue * 2),
                    ),
                    child: Text(
                      AppConfig.transText.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppConstants.defaultNumericValue),
          Text(
            "Select your gender to get noticed!",
            style: Theme.of(context)
                .textTheme
                .caption!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppConstants.defaultNumericValue * 2),
          Text(
            "My birthday is",
            style: Theme.of(context)
                .textTheme
                .headline5!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppConstants.defaultNumericValue),
          TextFormField(
            controller: birthdayController,
            autofocus: true,
            readOnly: true,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontWeight: FontWeight.bold),
            decoration: const InputDecoration(
              hintText: "MM/DD/YYYY",
              // border: InputBorder.none,
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please Select Your Birthday';
              }
              return null;
            },
            onTap: () {
              const duration =
                  Duration(days: 365 * AppConfig.minimumAgeRequired);
              showDatePicker(
                      context: context,
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now().subtract(duration),
                      initialDate:
                          birthday ?? DateTime.now().subtract(duration))
                  .then((value) {
                if (value != null) {
                  onBirthdaySelected(value);
                  birthdayController.text =
                      DateFormat("MM/dd/yyyy").format(value);
                }
              });
            },
          ),
          const SizedBox(height: AppConstants.defaultNumericValue),
          Text(
            "You must be ${AppConfig.minimumAgeRequired} years old to use this app!\nYour age will be shown to other users.",
            style: Theme.of(context)
                .textTheme
                .caption!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppConstants.defaultNumericValue * 2),
          Text(
            "My Interests",
            style: Theme.of(context)
                .textTheme
                .headline5!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppConstants.defaultNumericValue),
          Wrap(
            spacing: AppConstants.defaultNumericValue / 2,
            children: AppConfig.interests
                .map(
                  (interest) => ChoiceChip(
                    label:
                        Text(interest[0].toUpperCase() + interest.substring(1)),
                    selected: selectedInterests.contains(interest),
                    shape: selectedInterests.contains(interest)
                        ? RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                AppConstants.defaultNumericValue * 2),
                            side: BorderSide(
                                color: AppConstants.primaryColor, width: 1),
                          )
                        : null,
                    selectedColor: AppConstants.primaryColor.withOpacity(0.3),
                    onSelected: (notSelected) {
                      onSelectInterest(notSelected, interest);
                    },
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: AppConstants.defaultNumericValue),
          Text(
            "Please select your interests to get noticed!\nYou can select ${AppConfig.maxNumOfInterests} interests at most.",
            style: Theme.of(context)
                .textTheme
                .caption!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppConstants.defaultNumericValue * 2),
          CustomButton(onPressed: onNext, text: "Continue".toUpperCase()),
          const SizedBox(height: AppConstants.defaultNumericValue * 2),
        ],
      ),
    );
  }
}

class _UserLocationScreen extends StatelessWidget {
  final Function(UserLocation location) onLocationChanged;
  final UserLocation? location;
  final VoidCallback onNext;
  final VoidCallback onBack;
  const _UserLocationScreen({
    Key? key,
    required this.onLocationChanged,
    this.location,
    required this.onNext,
    required this.onBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.defaultNumericValue * 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "My location is",
            style: Theme.of(context)
                .textTheme
                .headline5!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppConstants.defaultNumericValue),
          // const SizedBox(
          //   height: 300,
          //   child: Center(
          //       child: Text(
          //     "Not Yet Implemented!\nYou can move on!",
          //     textAlign: TextAlign.center,
          //   )),
          // ),
          GestureDetector(
            onTap: () async {
              final location = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SetUserLocation(),
                  fullscreenDialog: true,
                ),
              );

              if (location != null) {
                onLocationChanged(location);
              }
            },
            child: Container(
              padding: const EdgeInsets.all(AppConstants.defaultNumericValue),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                ),
                borderRadius:
                    BorderRadius.circular(AppConstants.defaultNumericValue),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: AppConstants.defaultNumericValue),
                  Expanded(
                    child: Text(
                      location?.addressText ?? "Tap to set location",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppConstants.defaultNumericValue),
          Text(
            "You must set your location to use this app!\nOther users need to know the distance between you and them to use the app.",
            style: Theme.of(context)
                .textTheme
                .caption!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppConstants.defaultNumericValue * 2),
          Row(
            children: [
              Expanded(
                  child: CustomButton(
                      onPressed: onBack, text: "Back".toUpperCase())),
              const SizedBox(width: AppConstants.defaultNumericValue),
              Expanded(
                  child: CustomButton(
                      onPressed: onNext, text: "Continue".toUpperCase())),
            ],
          ),
          const SizedBox(height: AppConstants.defaultNumericValue * 2),
        ],
      ),
    );
  }
}
