import 'package:flutter/material.dart';
import 'package:testing/widgets/double_back_to_exit.dart';
import 'package:provider/provider.dart';
import 'package:testing/providers/auth_provider.dart';
import 'package:testing/layouts/main.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
        title: 'Profile',
        child: Scaffold(
          body: Center(
            child: Text(
              "ID: ${user?['data']['id'] ?? 'ID'}\nID: ${user?['data']['name'] ?? 'Name'}\nID: ${user?['data']['email'] ?? 'email'}\n",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
