import 'package:testing/services/api_service.dart';
import 'dart:async';

import 'package:flutter/material.dart';

class UserHelper {
  static Future<bool> checkUser(BuildContext context) async {
    final apiService = ApiService();
    final response = await apiService.sendRequest(
      method: 'GET',
      endpoint: '/user',
      useAuth: true,
    );
    if (response?.statusCode == 200) {
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => const DashboardPage()),
      // );
      return true;
    } else if (response == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            "Koneksi kamu sedang bermaslah, mencoba kembali dalam 5 detik",
          ),
        ),
      );

      // ⏳ Coba ulang dalam 3 detik
      Future.delayed(const Duration(seconds: 3), () {
        return checkUser(context); // retry otomatis
      });
      return false;
    } else {
      return false;
    }
  }

  static bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
    return emailRegex.hasMatch(email);
  }

  static String capitalizeName(String name) {
    if (name.isEmpty) return '';
    return name
        .split(' ')
        .map((word) {
          if (word.isEmpty) return '';
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ');
  }

  static bool isAdmin(Map<String, dynamic> user) {
    return user['role'] == 'admin';
  }

  static String getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return parts[0][0].toUpperCase() + parts[1][0].toUpperCase();
  }
}
