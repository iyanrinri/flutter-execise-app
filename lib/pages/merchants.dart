import 'package:flutter/material.dart';
import 'package:testing/widgets/double_back_to_exit.dart';
import 'package:provider/provider.dart';
import 'package:testing/providers/auth_provider.dart';
import 'package:testing/layouts/main.dart';

class MerchantsPage extends StatefulWidget {
  const MerchantsPage({super.key});

  @override
  State<MerchantsPage> createState() => _MerchantsPageState();
}

class _MerchantsPageState extends State<MerchantsPage> {
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
        title: 'Merchants',
        child: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 24.0, left: 24.0),
              child: Text(
                "Merchants Page",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
