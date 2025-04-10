import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MainLayout extends StatelessWidget {
  final String title;
  final Widget child;

  const MainLayout({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(title),
      drawer: _buildDrawer(context),
      body: SafeArea(child: child),
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

  Drawer _buildDrawer(BuildContext context) {
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
                _buildDrawerItem(context, Icons.people, 'Users', '/users'),
                _buildDrawerItem(context, Icons.person, 'News', '/news'),
              ],
            ),
          ),
          _buildDrawerItem(context, Icons.person, 'Profile', '/profile'),
          _buildLogoutItem(context),
        ],
      ),
    );
  }

  ListTile _buildLogoutItem(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.logout),
      title: const Text('Logout'),
      onTap: () async {
        // Create storage instance
        const storage = FlutterSecureStorage();

        // Delete token
        await storage.delete(key: 'token'); // Adjust key name as needed

        // Close drawer
        Navigator.pop(context);

        // Navigate to login screen (assuming '/login' is your login route)
        Navigator.pushReplacementNamed(context, '/login');
      },
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
}

class _AppConstants {
  static const String appIconPath = 'assets/icon/app_icon.png';
}
