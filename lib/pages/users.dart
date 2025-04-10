import 'package:flutter/material.dart';
import 'package:testing/widgets/double_back_to_exit.dart';
import 'package:provider/provider.dart';
import 'package:testing/providers/auth_provider.dart';
import 'package:testing/layouts/main.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user;
    return DoubleBackToExitWrapper(
      child: MainLayout(
        title: 'Users Management',
        child: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 24.0, left: 24.0),
              child: Text(
                "Users Management Page",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
