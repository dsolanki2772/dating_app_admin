import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReportsPage extends ConsumerWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const NavigationView(
      appBar: NavigationAppBar(
        title: Text('Reports'),
        leading: Icon(FluentIcons.list),
      ),
      content: Center(
        child: Text('Reports'),
      ),
    );
  }
}
