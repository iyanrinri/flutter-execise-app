import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthProvider with ChangeNotifier {
  final String baseAPI = dotenv.env['API_URL'].toString();
  final storage = const FlutterSecureStorage();
  String? _token;
  Map<String, dynamic>? _user;

  String? get token => _token;
  Map<String, dynamic>? get user => _user;

  Future<void> initUser() async {
    final storedToken = await storage.read(key: 'token');
    if (storedToken != null) {
      _token = storedToken;

      final userResponse = await http.get(
        Uri.parse('$baseAPI/user'),
        headers: {'Authorization': 'Bearer $_token'},
      );

      if (userResponse.statusCode == 200) {
        _user = jsonDecode(userResponse.body);
        notifyListeners();
      } else {
        // Token tidak valid, bisa dihapus
        await storage.delete(key: 'token');
        _token = null;
        _user = null;
      }
    }
  }


  Future login(String email, String password) async {
    if (baseAPI == 'null') {
      return {'status': false, 'message': 'Ups sesuatu yang salah, silahkan hubungi admin [000]'};
    }
    final response = await http.post(
      Uri.parse('$baseAPI/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      _token = data['access_token'];
      await storage.write(key: 'token', value: _token);

      final userResponse = await http.get(
        Uri.parse('$baseAPI/user'),
        headers: {'Authorization': 'Bearer $_token'},
      );

      if (userResponse.statusCode == 200) {
        _user = jsonDecode(userResponse.body);
        notifyListeners();
        return {'status': true, 'data': _user};
      }
    }
    final rawMessage = data['message'];

    final message = rawMessage is List
        ? rawMessage.join(', ')
        : rawMessage.toString();
    return {'status': false, 'message':message };
  }
}
