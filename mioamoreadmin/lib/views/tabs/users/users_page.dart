import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UsersPage extends ConsumerWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const NavigationView(
      appBar: NavigationAppBar(
        title: Text('Users'),
        leading: Icon(FluentIcons.people),
      ),
      content: Center(
        child: Text('Users'),
      ),
    );
  }
}
