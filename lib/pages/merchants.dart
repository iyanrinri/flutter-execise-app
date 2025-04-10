import 'package:flutter/material.dart';
import 'package:testing/services/api_service.dart';
import 'package:testing/widgets/double_back_to_exit.dart';

import '../layouts/main.dart';

class MerchantsPage extends StatefulWidget {
  const MerchantsPage({super.key});

  @override
  State<MerchantsPage> createState() => _MerchantsPageState();
}

class _MerchantsPageState extends State<MerchantsPage> {
  List<dynamic> merchants = [];
  bool isLoading = false;
  bool isLoadingMore = false;
  int currentPage = 1;
  bool hasMore = true;
  final apiService = ApiService();
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    fetchMerchants();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !isLoadingMore &&
        hasMore) {
      fetchMoreMerchants();
    }
  }

  Future<void> fetchMoreMerchants() async {
    setState(() => isLoadingMore = true);
    try {
      await Future.delayed(Duration(seconds: 1));
      if (!hasMore) {
        return;
      }
      final response = await apiService.sendRequest(
        method: 'GET',
        endpoint: '/merchants',
        useAuth: true,
        queryParameters: {'paginated': 1, 'page': currentPage + 1},
      );

      if (response?.statusCode == 200) {
        setState(() {
          var data = response?.data;
          currentPage++;
          merchants.addAll(data['data']); // Append new data
          hasMore =
              data['page'] == data['lastPage']
                  ? false
                  : true; // Adjust based on your API
          isLoadingMore = false;
        });
      }
    } catch (e) {
      print(e);
      setState(() => isLoadingMore = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching more merchants: $e')),
      );
    }
  }

  // GET all merchants (paginated)
  Future<void> fetchMerchants() async {
    setState(() => isLoading = true);
    try {
      await Future.delayed(Duration(seconds: 1));
      final response = await apiService.sendRequest(
        method: 'GET',
        endpoint: '/merchants',
        useAuth: true,
        queryParameters: {'paginated': 1},
      );

      if (response?.statusCode == 200) {
        setState(() {
          var data = response?.data;
          merchants =
              data['data']; // Adjust based on your API response structure
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error fetching merchants: $e')));
    }
  }

  // POST create merchant
  Future<void> createMerchant(String name) async {
    try {
      final response = await apiService.sendRequest(
        method: 'POST',
        endpoint: '/merchants',
        useAuth: true,
        data: {'name': name},
      );

      var statusCode = response?.statusCode;
      if (statusCode == 200 || statusCode == 201) {
        fetchMerchants();
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error creating merchant: $e')));
    }
  }

  // PUT update merchant
  Future<void> updateMerchant(String id, String name) async {
    try {
      final response = await apiService.sendRequest(
        method: 'PUT',
        endpoint: '/merchants/$id',
        useAuth: true,
        data: {'name': name},
      );

      var statusCode = response?.statusCode;
      if (statusCode == 200 || statusCode == 201) {
        fetchMerchants();
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error updating merchant: $e')));
    }
  }

  // DELETE merchant
  Future<void> deleteMerchant(String id) async {
    try {
      final response = await apiService.sendRequest(
        method: 'DELETE',
        endpoint: '/merchants/$id',
        useAuth: true,
      );

      if (response?.statusCode == 200) {
        fetchMerchants();
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error deleting merchant: $e')));
    }
  }

  // Show add/edit dialog
  void showMerchantDialog({Map<String, dynamic>? merchant}) {
    final nameController = TextEditingController(text: merchant?['name'] ?? '');

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(merchant == null ? 'Add Merchant' : 'Edit Merchant'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  if (merchant == null) {
                    createMerchant(nameController.text);
                  } else {
                    updateMerchant(
                      merchant['id'],
                      nameController.text
                    );
                  }
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DoubleBackToExitWrapper(
      child: MainLayout(
        title: 'Merchants',
        child: Scaffold(
          body:
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                    onRefresh: fetchMerchants,
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: merchants.length + (isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == merchants.length) {
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        final merchant = merchants[index];
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                right: 10,
                                left: 10,
                                bottom: 10,
                                top: 10,
                              ),
                              child: ListTile(
                                title: Text(
                                  merchant['name'],
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'User: ${merchant['user']['name']}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    Text(
                                      'Created: ${merchant['created_at_human']}',
                                    ),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed:
                                          () => showMerchantDialog(
                                            merchant: merchant,
                                          ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder:
                                              (context) => AlertDialog(
                                                title: const Text(
                                                  'Confirm Delete',
                                                ),
                                                content: const Text(
                                                  'Are you sure you want to delete this merchant?',
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed:
                                                        () => Navigator.pop(
                                                          context,
                                                        ),
                                                    child: const Text('Cancel'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      deleteMerchant(
                                                        merchant['id'],
                                                      );
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text('Delete'),
                                                  ),
                                                ],
                                              ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (index <
                                merchants.length -
                                    1) // Don't show divider after last item
                              Divider(
                                height: 1,
                                thickness: 1,
                                color: Colors.grey[300],
                              ),
                          ],
                        );
                      },
                    ),
                  ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => showMerchantDialog(),
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}
