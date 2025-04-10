import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:testing/providers/auth_provider.dart'; // Adjust import path as needed

class MainLayout extends StatefulWidget {
  final String title;
  final Widget child;
  final Widget? floatingActionButton;

  const MainLayout({super.key, required this.title, required this.child,
    this.floatingActionButton});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user;
    final String role =
        user?['data']?['role'] ?? ''; // Safe access with default

    return Scaffold(
      appBar: _buildAppBar(widget.title),
      drawer: _buildDrawer(context, role),
      floatingActionButton: widget.floatingActionButton,
      body: SafeArea(
        child: Padding(
          // padding: EdgeInsets.only(
          //   bottom: MediaQuery.of(context).viewPadding.bottom,
          // ),

          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewPadding.bottom + 16,
          ),
          child: widget.child,
        ),
      ),
    );
  }

  AppBar _buildAppBar(String title) {
    return AppBar(
      titleSpacing: 0,
      title: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Image.asset(
              _AppConstants.appIconPath,
              width: 38,
              height: 38,
            ),
          ),
          Text(title),
        ],
      ),
    );
  }

  Drawer _buildDrawer(BuildContext context, String role) {
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
                if (role == 'ADMIN') // Only show for ADMIN
                  _buildDrawerItem(context, Icons.people, 'Users', '/users'),
                _buildDrawerItem(context, Icons.person, 'News', '/news'),
              ],
            ),
          ),
          Divider(height: 1, thickness: 1, color: Colors.grey[300]),
          _buildDrawerItem(context, Icons.person, 'Profile', '/profile'),
          _buildLogoutItem(context),
          Padding(padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewPadding.bottom + 16,
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

  ListTile _buildDrawerItem(
    BuildContext context,
    IconData icon,
    String title,
    String routeName,
  ) {
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
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, '/login');
      },
    );
  }
}

class _AppConstants {
  static const String appIconPath = 'assets/icon/app_icon.png';
}
