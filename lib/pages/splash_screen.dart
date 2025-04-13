import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../widgets/double_back_to_exit.dart';
import 'login.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final storage = const FlutterSecureStorage();
  @override
  void initState() {
    super.initState();
    check();
  }

  Future<void> check() async {
    final token = await storage.read(key: 'token');
    if (token == null) {
      Timer(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DoubleBackToExitWrapper(
      child: Scaffold(
        body: Center(
          child: Image.asset(
            'assets/icon/app_icon.png',
            width: 150, // kamu bisa ubah sesuai kebutuhan
            height: 150,
          ),
        ),
      ),
    );
  }
}
