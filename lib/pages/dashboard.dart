import 'package:flutter/material.dart';
import 'package:testing/widgets/double_back_to_exit.dart';
import 'package:provider/provider.dart';
import 'package:testing/providers/auth_provider.dart';
import 'package:testing/layouts/main.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
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
        title: 'Dashboard',
        titleIcon: Icon(Icons.dashboard),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 24.0, left: 24.0),
            child: Text(
              "Halo ${user?['data']['name'] ?? 'User'}, kamu sudah login!",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
