import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mioamoreadmin/providers/auth_provider.dart';

class MyErrorWidget extends StatelessWidget {
  const MyErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const NavigationView(
      content: Center(
        child: Text(
          "Something went wrong!\nPlease try again later!",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class MyLoadingWidget extends StatelessWidget {
  const MyLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const NavigationView(
      content: Center(
        child: ProgressRing(),
      ),
    );
  }
}

class NotAdminWidget extends StatelessWidget {
  const NotAdminWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      content: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "You are not an admin!\nPlease contact the admin!",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton(
              child: const Text("Logout"),
              onPressed: () async {
                EasyLoading.show(status: "Logging out...");
                await AuthProvider.logout().then((value) {
                  EasyLoading.dismiss();
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
