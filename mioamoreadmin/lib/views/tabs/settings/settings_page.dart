import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mioamoreadmin/providers/auth_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return NavigationView(
      appBar: const NavigationAppBar(
        title: Text("Settings"),
        leading: Icon(FluentIcons.settings),
      ),
      content: Align(
        alignment: Alignment.topLeft,
        child: Container(
          padding: const EdgeInsets.all(16),
          width: 400,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: const Text("Change Name"),
                        subtitle: const Text("Change your full name"),
                        leading: const Icon(FluentIcons.edit),
                        trailing: const Icon(FluentIcons.chevron_right),
                        onPressed: () {},
                      ),
                      ListTile(
                        title: const Text("Change Email"),
                        subtitle: const Text("Change your email address"),
                        leading: const Icon(FluentIcons.edit_mail),
                        trailing: const Icon(FluentIcons.chevron_right),
                        onPressed: () {},
                      ),
                      ListTile(
                        title: const Text("Change Password"),
                        subtitle: const Text("Change your password"),
                        leading: const Icon(FluentIcons.password_field),
                        trailing: const Icon(FluentIcons.chevron_right),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(),
              ListTile(
                title: const Text("Logout"),
                subtitle: const Text("Logout of your account"),
                leading: const Icon(FluentIcons.sign_out),
                trailing: const Icon(FluentIcons.chevron_right),
                onPressed: () async {
                  EasyLoading.show(status: 'Logging out...');
                  await AuthProvider.logout();
                  EasyLoading.dismiss();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
