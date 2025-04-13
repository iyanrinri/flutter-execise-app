// users_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testing/pages/users/users_controller.dart';
import 'package:testing/pages/users/users_tile.dart';
import 'package:testing/widgets/double_back_to_exit.dart';
import 'package:testing/layouts/main.dart';
import 'package:testing/pages/users/users_model.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UsersController>().fetchUsers(isRefresh: true);
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    final controller = context.read<UsersController>();
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent &&
        !controller.isLoading &&
        controller.hasMore) {
      controller.fetchUsers();
    }
  }

  void showUserDialog({User? user}) {
    final nameController = TextEditingController(text: user?.name ?? '');
    final controller = context.read<UsersController>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(user == null ? 'Add User' : 'Edit User'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'Name'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              if (user == null) {
                await controller.createUser(nameController.text);
              } else {
                await controller.updateUser(user.id, nameController.text);
              }
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<UsersController>();
    return DoubleBackToExitWrapper(
      child: MainLayout(
        title: 'Users',
        titleIcon: const Icon(Icons.store),
        floatingActionButton: FloatingActionButton(
          onPressed: () => showUserDialog(),
          child: const Icon(Icons.add),
        ),
        child: controller.isLoading && controller.users.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
          onRefresh: () => controller.fetchUsers(isRefresh: true),
          child: ListView.builder(
            controller: _scrollController,
            itemCount: controller.users.length + (controller.isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == controller.users.length) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final user = controller.users[index];
              return UserTile(
                user: user,
                onEdit: () => showUserDialog(user: user),
                onDelete: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Confirm Delete'),
                      content: const Text('Are you sure you want to delete this user?'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                        TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    await controller.deleteUser(user.id);
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
