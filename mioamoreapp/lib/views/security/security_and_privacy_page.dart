import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mioamoreapp/models/user_profile_model.dart';
import 'package:mioamoreapp/providers/user_profile_provider.dart';
import 'package:mioamoreapp/views/others/error_page.dart';
import 'package:mioamoreapp/views/others/loading_page.dart';
import 'package:mioamoreapp/views/security/blocking_page.dart';
import 'package:mioamoreapp/views/settings/verification/verification_steps.dart';

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
          ListTile(
            leading: const Icon(Icons.verified_user),
            title: const Text('Verification Status'),
            subtitle: Text(
              widget.user.isVerified ? "Verified" : "Not Verified",
              style: Theme.of(context).textTheme.subtitle2!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: widget.user.isVerified ? Colors.green : Colors.red),
            ),
            onTap: (widget.user.isVerified)
                ? null
                : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              GetVerifiedPage(user: widget.user)),
                    );
                  },
          ),
          const Divider(),
        ],
      ),
    );
  }
}
