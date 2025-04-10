import 'dart:async';

import 'package:flutter/material.dart';
import '../widgets/double_back_to_exit.dart';
import 'login.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
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
