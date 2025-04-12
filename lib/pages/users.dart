import 'package:flutter/material.dart';
import 'package:testing/widgets/double_back_to_exit.dart';
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
    return DoubleBackToExitWrapper(
      child: MainLayout(
        title: 'Users Management',
        titleIcon: Icon(Icons.people),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 24.0, left: 24.0),
            child: Text(
              "Users Management Page",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
