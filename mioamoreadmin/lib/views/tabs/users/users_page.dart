import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mioamoreadmin/helpers/firebase_constants.dart';
import 'package:mioamoreadmin/models/user_profile_model.dart';
import 'package:mioamoreadmin/views/tabs/users/user_details_page.dart';
import 'package:paginate_firestore_plus/bloc/pagination_listeners.dart';
import 'package:paginate_firestore_plus/paginate_firestore.dart';

PaginateRefreshedChangeListener customerListRefreshListener =
    PaginateRefreshedChangeListener();

class UsersPage extends ConsumerStatefulWidget {
  const UsersPage({super.key});

  @override
  ConsumerState<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends ConsumerState<UsersPage> {
  bool _isLoading = false;
  final _searchByEmailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String email = _searchByEmailController.text.trim();

    final query = email.isNotEmpty
        ? FirebaseFirestore.instance
            .collection(FirebaseConstants.userProfileCollection)
            .where("email", isEqualTo: email.toLowerCase())
        : FirebaseFirestore.instance
            .collection(FirebaseConstants.userProfileCollection);

    return NavigationView(
      appBar: NavigationAppBar(
        leading: const SizedBox(),
        title: Row(
          children: [
            Text('Users', style: FluentTheme.of(context).typography.bodyStrong),
            const SizedBox(width: 16),
            SizedBox(
              width: 400,
              height: 32,
              child: TextBox(
                controller: _searchByEmailController,
                placeholder: "Search by Email",
                suffix: Row(
                  children: [
                    IconButton(
                      icon: const Icon(FluentIcons.clear),
                      onPressed: () async {
                        setState(() {
                          _isLoading = true;
                        });
                        _searchByEmailController.clear();
                        await Future.delayed(const Duration(milliseconds: 200));
                        setState(() {
                          _isLoading = false;
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      child: const Text("Search"),
                      onPressed: () async {
                        setState(() {
                          _isLoading = true;
                        });
                        await Future.delayed(const Duration(milliseconds: 500));
                        setState(() {
                          _isLoading = false;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            IconButton(
              icon: const Icon(FluentIcons.refresh),
              onPressed: () {
                customerListRefreshListener.refreshed = true;
              },
            ),
          ],
        ),
      ),
      content: _isLoading
          ? const Center(child: ProgressRing())
          : PaginateFirestore(
              bottomLoader: const Center(child: ProgressRing()),
              initialLoader: const Center(child: ProgressRing()),
              onEmpty: const Center(child: Text("No data found")),
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, documentSnapshots, index) {
                final data =
                    documentSnapshots[index].data() as Map<String, dynamic>;
                final UserProfileModel items = UserProfileModel.fromMap(data);
                return CustomerListItemCard(user: items, index: index);
              },
              query: query,
              itemBuilderType: PaginateBuilderType.listView,
              itemsPerPage: 20,
              listeners: [customerListRefreshListener],
            ),
    );
  }
}

class CustomerListItemCard extends StatelessWidget {
  final UserProfileModel user;
  final int index;
  final Function(UserProfileModel)? onSelected;
  const CustomerListItemCard({
    super.key,
    required this.user,
    required this.index,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: SelectableText(user.fullName),
        leading: CircleAvatar(
          backgroundImage: user.profilePicture == null
              ? null
              : CachedNetworkImageProvider(user.profilePicture!),
          child: user.profilePicture == null
              ? SelectableText(user.fullName[0].toUpperCase())
              : null,
        ),
        subtitle: SelectableText(user.email ?? user.phoneNumber ?? ""),
        trailing: FilledButton(
          child: onSelected == null ? const Text("View") : const Text("Select"),
          onPressed: () {
            if (onSelected != null) {
              onSelected!(user);
            } else {
              Navigator.of(context).push(
                FluentPageRoute(
                  builder: (context) {
                    return UserDetailsPage(userId: user.userId);
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
