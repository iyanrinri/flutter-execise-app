import 'package:flutter/material.dart';
import 'package:testing/pages/dashboard.dart';
import 'package:testing/pages/login.dart';
import 'dart:async';
import '../services/api_service.dart';
import '../widgets/double_back_to_exit.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    checkUser();
  }

  void checkUser() async {
    Future.microtask(() async {
      final apiService = ApiService();
      final response = await apiService.sendRequest(
        method: 'GET',
        endpoint: '/user',
        useAuth: true,
      );
      if (response?.statusCode == 200) {
        if (ModalRoute.of(context)?.settings.name == '/login') {
          Timer(const Duration(seconds: 1), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const DashboardPage()),
            );
          });
        }
      } else if (response == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: Colors.redAccent, content: Text("Koneksi kamu sedang bermaslah, mencoba kembali dalam 5 detik")),
        );

        // ⏳ Coba ulang dalam 3 detik
        Future.delayed(const Duration(seconds: 3), () {
          checkUser(); // retry otomatis
        });
      } else {
        // Simulasi delay splash screen
        Timer(const Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        });
      }
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
