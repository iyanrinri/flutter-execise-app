import 'package:flutter/material.dart';
import 'package:testing/pages/users/users_model.dart';
import 'package:testing/services/api_service.dart';

class UsersController with ChangeNotifier {
  final apiService = ApiService();

  List<User> users = [];
  bool isLoading = false;
  bool isLoadingMore = false;
  int currentPage = 1;
  bool hasMore = true;

  Future<void> fetchUsers({bool isRefresh = false}) async {
    if (isRefresh) {
      currentPage = 1;
      hasMore = true;
    }
    isLoading = true;
    notifyListeners();
    try {
      final response = await apiService.sendRequest(
        method: 'GET',
        endpoint: '/users',
        useAuth: true,
        queryParameters: {'paginated': 1, 'page': currentPage},
      );
      if (response?.statusCode == 200) {
        var data = response?.data;
        if (isRefresh) {
          users = (data['data'] as List).map((e) => User.fromJson(e)).toList();
        } else {
          users.addAll(data['data']);
        }
        hasMore = data['page'] != data['lastPage'];
        currentPage++;
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createUser(String name) async {
    await apiService.sendRequest(
      method: 'POST',
      endpoint: '/users',
      useAuth: true,
      data: {'name': name},
    );
    await fetchUsers(isRefresh: true);
  }

  Future<void> updateUser(String id, String name) async {
    await apiService.sendRequest(
      method: 'PUT',
      endpoint: '/users/$id',
      useAuth: true,
      data: {'name': name},
    );
    await fetchUsers(isRefresh: true);
  }

  Future<void> deleteUser(String id) async {
    await apiService.sendRequest(
      method: 'DELETE',
      endpoint: '/users/$id',
      useAuth: true,
    );
    await fetchUsers(isRefresh: true);
  }
}
