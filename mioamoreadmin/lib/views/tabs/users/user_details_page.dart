import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mioamoreadmin/models/user_profile_model.dart';
import 'package:mioamoreadmin/providers/user_profiles_provider.dart';
import 'package:mioamoreadmin/views/others/other_widgets.dart';

class UserDetailsPage extends ConsumerStatefulWidget {
  final String userId;
  const UserDetailsPage({
    super.key,
    required this.userId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserDetailsPageState();
}

class _UserDetailsPageState extends ConsumerState<UserDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final userProfileRef = ref.watch(userProfileProvider(widget.userId));

    return userProfileRef.when(
      data: (profile) {
        return NavigationView(
          appBar: NavigationAppBar(title: Text(profile.fullName)),
          content: Align(
            alignment: Alignment.topLeft,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  UserDetailsProfileCard(profile: profile),
                  UserDetailsAccountSettingsCard(profile: profile),
                ],
              ),
            ),
          ),
        );
      },
      error: (error, stackTrace) => const MyErrorWidget(),
      loading: () => const MyLoadingWidget(),
    );
  }
}

class UserDetailsAccountSettingsCard extends StatelessWidget {
  final UserProfileModel profile;
  const UserDetailsAccountSettingsCard({
    Key? key,
    required this.profile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            Text(
              "User Account Settings",
              style: FluentTheme.of(context).typography.subtitle,
            ),
            const SizedBox(height: 16),
            TextBox(
              readOnly: true,
              header: 'Location',
              maxLines: null,
              initialValue:
                  profile.userAccountSettingsModel.location.addressText,
            ),
            const SizedBox(height: 16),
            TextBox(
              readOnly: true,
              header: "Interested In",
              initialValue:
                  profile.userAccountSettingsModel.interestedIn ?? "All",
            ),
            const SizedBox(height: 16),
            TextBox(
              readOnly: true,
              header: "Age Range",
              initialValue:
                  "${profile.userAccountSettingsModel.minimumAge} - ${profile.userAccountSettingsModel.maximumAge}",
            ),
            const SizedBox(height: 16),
            // Distance Range
            TextBox(
              readOnly: true,
              header: "Distance Radius",
              initialValue:
                  "${profile.userAccountSettingsModel.distanceInKm ?? "Unknown"} km",
            ),
          ],
        ),
      ),
    );
  }
}

class UserDetailsProfileCard extends StatelessWidget {
  final UserProfileModel profile;
  const UserDetailsProfileCard({
    Key? key,
    required this.profile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            if (profile.profilePicture != null)
              Center(
                child: CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(
                    profile.profilePicture!,
                  ),
                  radius: 70,
                ),
              ),
            if (profile.profilePicture == null)
              Center(
                child: CircleAvatar(
                  radius: 50,
                  child: Text(
                    profile.fullName[0],
                    style: const TextStyle(fontSize: 30),
                  ),
                ),
              ),
            const SizedBox(height: 16),
            TextBox(
              readOnly: true,
              header: 'Full Name',
              initialValue: profile.fullName,
            ),
            const SizedBox(height: 8),
            TextBox(
              readOnly: true,
              header: 'Email',
              initialValue: profile.email,
            ),
            const SizedBox(height: 8),
            TextBox(
              readOnly: true,
              header: 'Phone Number',
              initialValue: profile.phoneNumber,
            ),
            const SizedBox(height: 8),
            TextBox(
              readOnly: true,
              maxLines: null,
              header: 'About',
              initialValue: profile.about,
            ),
            const SizedBox(height: 8),
            TextBox(
              readOnly: true,
              initialValue: profile.interests.join(', '),
              header: 'Interests',
            ),
            const SizedBox(height: 8),
            const Text("Images"),
            const SizedBox(height: 8),
            Wrap(
              alignment: WrapAlignment.start,
              spacing: 4,
              runSpacing: 4,
              children: profile.mediaFiles
                  .map(
                    (e) => CachedNetworkImage(
                      imageUrl: e,
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
