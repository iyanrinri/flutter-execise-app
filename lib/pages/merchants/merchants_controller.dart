import 'package:flutter/material.dart';
import 'package:testing/pages/merchants/merchants_model.dart';
import 'package:testing/services/api_service.dart';

class MerchantsController with ChangeNotifier {
  final apiService = ApiService();

  List<Merchant> merchants = [];
  bool isLoading = false;
  bool isLoadingMore = false;
  int currentPage = 1;
  bool hasMore = true;

  Future<void> fetchMerchants({bool isRefresh = false}) async {
    if (isRefresh) {
      currentPage = 1;
      hasMore = true;
    }
    isLoading = true;
    notifyListeners();
    try {
      final response = await apiService.sendRequest(
        method: 'GET',
        endpoint: '/merchants',
        useAuth: true,
        queryParameters: {'paginated': 1, 'page': currentPage},
      );
      if (response?.statusCode == 200) {
        var data = response?.data;
        if (isRefresh) {
          merchants = (data['data'] as List).map((e) => Merchant.fromJson(e)).toList();
        } else {
          merchants.addAll(data['data']);
        }
        hasMore = data['page'] != data['lastPage'];
        currentPage++;
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createMerchant(String name) async {
    await apiService.sendRequest(
      method: 'POST',
      endpoint: '/merchants',
      useAuth: true,
      data: {'name': name},
    );
    await fetchMerchants(isRefresh: true);
  }

  Future<void> updateMerchant(String id, String name) async {
    await apiService.sendRequest(
      method: 'PUT',
      endpoint: '/merchants/$id',
      useAuth: true,
      data: {'name': name},
    );
    await fetchMerchants(isRefresh: true);
  }

  Future<void> deleteMerchant(String id) async {
    await apiService.sendRequest(
      method: 'DELETE',
      endpoint: '/merchants/$id',
      useAuth: true,
    );
    await fetchMerchants(isRefresh: true);
  }
}
