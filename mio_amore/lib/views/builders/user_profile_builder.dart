// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:mio_amore/models/user_profile_model.dart';
// import 'package:mio_amore/providers/user_profile_provider.dart';

// class UserProfileBuilder extends ConsumerWidget {
//   final Widget Function(UserProfileModel? userProfileModel) builder;
//   const UserProfileBuilder({
//     Key? key,
//     required this.builder,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final _userProfile = ref.watch(userProfileProvider);
//     return _userProfile.when(
//       data: (data) {
//         return builder(data);
//       },
//       error: (_, e) {
//         return builder(null);
//       },
//       loading: () => const Center(child: CircularProgressIndicator()),
//     );
//   }
// }
