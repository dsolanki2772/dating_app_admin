import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const NavigationView(
      appBar: NavigationAppBar(
        title: Text('Dashboard'),
        leading: Icon(FluentIcons.view_dashboard),
      ),
      content: Center(
        child: Text('Dashboard'),
      ),
    );
  }
}
