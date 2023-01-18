import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mioamoreadmin/helpers/number_formatter.dart';
import 'package:mioamoreadmin/providers/devices_provider.dart';
import 'package:mioamoreadmin/providers/interactions_provider.dart';
import 'package:mioamoreadmin/providers/matches_provider.dart';
import 'package:mioamoreadmin/providers/user_profiles_provider.dart';
import 'package:mioamoreadmin/views/tabs/dashboard/dashboard_card.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalUsersRef = ref.watch(usersShortStreamProvider);
    final totalInteractionsRef = ref.watch(totalInteractionsProvider);
    final totalMatchesRef = ref.watch(totalMatchesProvider);
    final totalDevicesRef = ref.watch(totalDevicesProvider);
    return NavigationView(
      appBar: const NavigationAppBar(
        title: Text('Dashboard'),
        leading: Icon(FluentIcons.view_dashboard),
      ),
      content: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Align(
          alignment: Alignment.topLeft,
          child: Wrap(
            alignment: WrapAlignment.start,
            spacing: 16,
            runSpacing: 16,
            children: [
              totalUsersRef.when(
                data: (totalUsers) {
                  final male = totalUsers
                      .where((element) => element.gender == "male")
                      .toList();
                  final female = totalUsers
                      .where((element) => element.gender == "female")
                      .toList();
                  return DashboardCard(
                    title: 'Total Users',
                    value: NumberFormatter.formatNumber(totalUsers.length),
                    icon: FluentIcons.people,
                    color: Colors.blue,
                    subtitle:
                        "Male: ${NumberFormatter.formatNumber(male.length)} | Female: ${NumberFormatter.formatNumber(female.length)}",
                  );
                },
                loading: () => const SizedBox(),
                error: (error, stack) => const SizedBox(),
              ),
              totalInteractionsRef.when(
                data: (totalInteractions) {
                  final likes = totalInteractions
                      .where((element) => element.isLike)
                      .toList();

                  final dislikes = totalInteractions
                      .where((element) => element.isDislike)
                      .toList();

                  final superLikes = totalInteractions
                      .where((element) => element.isSuperLike)
                      .toList();

                  return DashboardCard(
                    title: 'Total Interactions',
                    value:
                        NumberFormatter.formatNumber(totalInteractions.length),
                    icon: FluentIcons.add_connection,
                    color: Colors.teal,
                    subtitle:
                        "Likes: ${NumberFormatter.formatNumber(likes.length)} | Dislikes: ${NumberFormatter.formatNumber(dislikes.length)} | Super Likes: ${NumberFormatter.formatNumber(superLikes.length)}",
                  );
                },
                loading: () => const SizedBox(),
                error: (error, stack) => const SizedBox(),
              ),
              totalMatchesRef.when(
                data: (totalMatches) => DashboardCard(
                  title: 'Total Matches',
                  value: NumberFormatter.formatNumber(totalMatches.length),
                  icon: FluentIcons.connect_contacts,
                  color: Colors.magenta,
                ),
                loading: () => const SizedBox(),
                error: (error, stack) => const SizedBox(),
              ),
              totalDevicesRef.when(
                data: (totalDevices) => DashboardCard(
                  title: 'Total Logged In Devices',
                  value: NumberFormatter.formatNumber(totalDevices),
                  icon: FluentIcons.cell_phone,
                  color: Colors.orange,
                ),
                loading: () => const SizedBox(),
                error: (error, stack) => const SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
