import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mioamoreadmin/providers/user_reports_provider.dart';
import 'package:mioamoreadmin/views/others/other_widgets.dart';
import 'package:mioamoreadmin/views/tabs/users/user_short_card.dart';

class ReportsPage extends ConsumerWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allReportsRef = ref.watch(allReportsProvider);

    return NavigationView(
      appBar: const NavigationAppBar(
        title: Text('Reports'),
        leading: Icon(FluentIcons.list),
      ),
      content: allReportsRef.when(
        data: (data) {
          data.sort((a, b) => b.reportsCount.compareTo(a.reportsCount));

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final userReports = data[index];
              return Card(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: UserShortCard(userId: userReports.userId),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      '${userReports.reportsCount} ${userReports.reportsCount == 1 ? 'report' : 'reports'}',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],
                ),
              );
            },
          );
        },
        error: (error, stackTrace) => const MyErrorWidget(),
        loading: () => const MyLoadingWidget(),
      ),
    );
  }
}
