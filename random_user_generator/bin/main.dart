import 'dart:io';
import 'dart:math';
import 'package:random_user_generator/random_user_model.dart';
import 'package:random_user_generator/random_user_provider.dart';
import 'package:random_user_generator/user_account_settings_model.dart';
import 'package:random_user_generator/user_profile_model.dart';

void main(List<String> arguments) async {
  final RandomUserModel? randomUserModel = await getRandomUsers();

  List<UserProfileModel> randomUserProfiles = [];

  if (randomUserModel != null) {
    for (var random in randomUserModel.results) {
      final List<String> randomInterests = [];

      while (randomInterests.length < 5) {
        final String randomInterest =
            interests[Random().nextInt(interests.length)];
        if (!randomInterests.contains(randomInterest)) {
          randomInterests.add(randomInterest);
        }
      }

      UserLocation location = UserLocation(
        addressText:
            "${random.location.street.name}, ${random.location.city}, ${random.location.state}, ${random.location.country}",
        latitude: double.parse(random.location.coordinates.latitude),
        longitude: double.parse(random.location.coordinates.longitude),
      );
      UserAccountSettingsModel settings = UserAccountSettingsModel(
        location: location,
        minimumAge: 18,
        maximumAge: 50,
      );

      UserProfileModel profile = UserProfileModel(
        id: random.login.uuid,
        userId: random.login.uuid,
        fullName:
            '${random.name.title} ${random.name.first} ${random.name.last}',
        gender: random.gender.name.toLowerCase(),
        birthDay: random.dob.date,
        mediaFiles: [],
        interests: randomInterests,
        userAccountSettingsModel: settings,
        isVerified: Random().nextBool(),
        isOnline: Random().nextBool(),
        email: random.email,
        phoneNumber: random.phone,
        profilePicture: random.picture.large,
        about: aboutList[Random().nextInt(aboutList.length)],
      );

      randomUserProfiles.add(profile);
    }
  }

  List<String> randomUserJson = [];

  for (var element in randomUserProfiles) {
    randomUserJson.add(element.toJson());
  }

  final Directory systemTempDir = Directory.current;
  final File file = File('${systemTempDir.path}/random_users.json');

  // debugPrint('Writing to file: ${file.path}...');
  file.writeAsStringSync(randomUserJson.toString());
}

List<String> interests = [
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
];

List<String> aboutList = [
  "I'm here waiting for you to say hi!",
  "I'm a very outgoing person and I love to meet new people!",
  "I'm a very shy person, but I'm willing to try new things!",
  "Hey there, Let's chat!",
  "What's up?",
  "Let's hang out!",
  "I'm looking for someone to hang out with!",
  "I'm looking for someone to go on a date with!",
  "I'm looking for someone to go on a trip with!",
  "I'm looking for someone to go on a vacation with!",
];
