import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MainLayout extends StatefulWidget {
  final String title;
  final Widget child;
  final Widget? floatingActionButton;
  final Icon ?titleIcon;

  const MainLayout({super.key, required this.title, required this.child,
    this.floatingActionButton, this.titleIcon});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  Map<String, dynamic>? user;

  @override
  void initState() {
    super.initState();
    checkUser();
  }

  Future<void> checkUser() async {
    const storage = FlutterSecureStorage();
    final userJson = await storage.read(key: 'user');
    if (userJson != null) {
      final userData = jsonDecode(userJson);
      setState(() {
        user = userData['data'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: _buildAppBar(widget.title),
      drawer: _buildDrawer(context),
      floatingActionButton: widget.floatingActionButton,
      body: SafeArea(
        child: Padding(
          // padding: EdgeInsets.only(
          //   bottom: MediaQuery.of(context).viewPadding.bottom,
          // ),

          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery
                .of(context)
                .viewPadding
                .bottom + 16,
          ),
          child: widget.child,
        ),
      ),
    );
  }

  Image _logo() {
    return Image.asset(
      _AppConstants.appIconPath,
      width: 38,
      height: 38,
    );
  }

  AppBar _buildAppBar(String title) {
    return AppBar(
      titleSpacing: 0,
      title: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: widget.titleIcon ?? _logo(),
          ),
          Text(title),
        ],
      ),
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    if (user == null) {
      return const Drawer(child: Center(child: CircularProgressIndicator()));
    }
    var currentRole = user?['role'] ?? 'USER';
    return Drawer(
      child: Column(
        children: [
          _buildDrawerHeader(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  context,
                  Icons.dashboard,
                  'Dashboard',
                  '/dashboard',
                ),
                _buildDrawerItem(
                  context,
                  Icons.store,
                  'Merchants',
                  '/merchants',
                ),
                if (currentRole == 'ADMIN') // Only show for ADMIN
                  _buildDrawerItem(context, Icons.people, 'Users', '/users'),
                _buildDrawerItem(context, Icons.person, 'News', '/news'),
                _buildDrawerItem(
                  context,
                  Icons.map,
                  'Map Playground',
                  '/map-playground',
                ),
              ],
            ),
          ),
          Divider(height: 1, thickness: 1, color: Colors.grey[300]),
          _buildDrawerItem(context, Icons.person, 'Profile', '/profile'),
          _buildLogoutItem(context),
          Padding(padding: EdgeInsets.only(
            bottom: MediaQuery
                .of(context)
                .viewPadding
                .bottom + 16,
          ))
        ],
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return DrawerHeader(
      decoration: const BoxDecoration(color: Colors.blue),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Image.asset(
              _AppConstants.appIconPath,
              width: 38,
              height: 38,
            ),
          ),
          const Text(
            "Yuk Antri",
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        ],
      ),
    );
  }

  ListTile _buildDrawerItem(BuildContext context,
      IconData icon,
      String title,
      String routeName,) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pushReplacementNamed(context, routeName);
      },
    );
  }

  ListTile _buildLogoutItem(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.logout),
      title: const Text('Logout'),
      onTap: () async {
        const storage = FlutterSecureStorage();
        await storage.delete(key: 'token');
        await storage.delete(key: 'user');
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, '/login');
      },
    );
  }
}

class _AppConstants {
  static const String appIconPath = 'assets/icon/app_icon.png';
}
