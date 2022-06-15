import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mio_amore/models/user_profile_model.dart';
import 'package:mio_amore/providers/user_profile_provider.dart';
import 'package:mio_amore/views/others/error_page.dart';
import 'package:mio_amore/views/others/loading_page.dart';
import 'package:mio_amore/views/security/blocking_page.dart';

class SecurityAndPrivacyLandingPage extends ConsumerWidget {
  const SecurityAndPrivacyLandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProfileFutureProvider);

    return user.when(
      data: (data) {
        return data == null
            ? const ErrorPage()
            : SecurityAndPrivacyPage(user: data);
      },
      error: (_, __) => const ErrorPage(),
      loading: () => const LoadingPage(),
    );
  }
}

class SecurityAndPrivacyPage extends ConsumerStatefulWidget {
  final UserProfileModel user;
  const SecurityAndPrivacyPage({Key? key, required this.user})
      : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SecurityAndPrivacyPageState();
}

class _SecurityAndPrivacyPageState
    extends ConsumerState<SecurityAndPrivacyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Security and Privacy'),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        children: [
          ListTile(
            leading: const Icon(Icons.block),
            title: const Text('Blocking'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BlockingPage()),
              );
            },
          ),
          const Divider(),
        ],
      ),
    );
  }
}
