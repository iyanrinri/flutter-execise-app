// merchants_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testing/pages/merchants/merchants_controller.dart';
import 'package:testing/pages/merchants/merchants_tile.dart';
import 'package:testing/widgets/double_back_to_exit.dart';
import 'package:testing/layouts/main.dart';
import 'package:testing/pages/merchants/merchants_model.dart';

class MerchantsPage extends StatefulWidget {
  const MerchantsPage({super.key});

  @override
  State<MerchantsPage> createState() => _MerchantsPageState();
}

class _MerchantsPageState extends State<MerchantsPage> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MerchantsController>().fetchMerchants(isRefresh: true);
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    final controller = context.read<MerchantsController>();
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent &&
        !controller.isLoading &&
        controller.hasMore) {
      controller.fetchMerchants();
    }
  }

  void showMerchantDialog({Merchant? merchant}) {
    final nameController = TextEditingController(text: merchant?.name ?? '');
    final controller = context.read<MerchantsController>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(merchant == null ? 'Add Merchant' : 'Edit Merchant'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'Name'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              if (merchant == null) {
                await controller.createMerchant(nameController.text);
              } else {
                await controller.updateMerchant(merchant.id, nameController.text);
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
    final controller = context.watch<MerchantsController>();
    return DoubleBackToExitWrapper(
      child: MainLayout(
        title: 'Merchants',
        titleIcon: const Icon(Icons.store),
        floatingActionButton: FloatingActionButton(
          onPressed: () => showMerchantDialog(),
          child: const Icon(Icons.add),
        ),
        child: controller.isLoading && controller.merchants.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
          onRefresh: () => controller.fetchMerchants(isRefresh: true),
          child: ListView.builder(
            controller: _scrollController,
            itemCount: controller.merchants.length + (controller.isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == controller.merchants.length) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final merchant = controller.merchants[index];
              return MerchantTile(
                merchant: merchant,
                onEdit: () => showMerchantDialog(merchant: merchant),
                onDelete: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Confirm Delete'),
                      content: const Text('Are you sure you want to delete this merchant?'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                        TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    await controller.deleteMerchant(merchant.id);
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
