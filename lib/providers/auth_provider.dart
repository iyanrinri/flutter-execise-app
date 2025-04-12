import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:testing/services/api_service.dart';

class AuthProvider with ChangeNotifier {
  final storage = const FlutterSecureStorage();
  final _apiService = ApiService();
  String? _token;
  Map<String, dynamic>? _user;

  String? get token => _token;

  Map<String, dynamic>? get user => _user;

  AuthProvider() {
    _loadToken();
  }

  Future<void> _loadToken() async {
    _token = await storage.read(key: 'token');
    notifyListeners();
  }

  Future<void> saveToken(String token) async {
    _token = token;
    await storage.write(key: 'token', value: token);
    notifyListeners();
  }

  Future<void> clearToken() async {
    _token = null;
    await storage.delete(key: 'token');
    notifyListeners();
  }

  Future initUser() async {
    final storedToken = await storage.read(key: 'token');
    if (storedToken != null) {
      _token = storedToken;

      final userResponse = await _apiService.sendRequest(
        method: 'GET',
        endpoint: '/user',
        useAuth: true,
      );

      if (userResponse?.statusCode == 200) {
        _user = userResponse?.data;
        return {'status': true, 'data': _user};
      } else {
        // Token tidak valid, bisa dihapus
        await storage.delete(key: 'token');
        _token = null;
        _user = null;
      }
    }
    return {'status': false, 'message': 'Invalid token'};
  }

  Future login(String email, String password) async {
    final response = await _apiService.sendRequest(
      method: 'POST',
      endpoint: '/auth/login',
      data: {'email': email, 'password': password},
    );

    if (response == null) {
      return {
        'status': false,
        'message': 'Something wrong with your Network try again in few minutes',
      };
    }
    final statusCode = response.statusCode ?? 500;
    final resData = response.data;
    final data = {
      'status': false,
      'message': 'Session kamu tidak valid/kadarluasa',
    };
    if (resData != null) {
      final data = response.data;
      if (statusCode == 200) {
        _token = data['access_token'];
        await storage.write(key: 'token', value: _token);
        await storage.write(key: 'access_token', value: _token);
        final userResponse = await initUser();

        if (userResponse['status'] == true) {
          notifyListeners();
          return userResponse;
        }
        data['status'] = false;
        data['message'] = 'Session kamu tidak valid/kadarluasa';
      } else {
        final responseData = response.data;
        final message = responseData['message'] ?? 'Terjadi kesalahan yang tidak diketahui.' ;
        var errorMsg = 'Terjadi kesalahan yang tidak diketahui.';

        if (message is String) {
          errorMsg = message;
        } else {
          errorMsg = message.join(' ');
        }
        return {'status': false, 'message': errorMsg};
      }
    }

    final rawMessage = data['message'];

    final message =
        rawMessage is List ? rawMessage.join(', ') : rawMessage.toString();

    return {'status': false, 'message': message};
  }
}
