import 'package:flutter/material.dart';

class MainLayout extends StatelessWidget {
  final String title;
  final Widget child;

  const MainLayout({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Image.asset(
                'assets/icon/app_icon.png',
                width: 38, // kamu bisa ubah sesuai kebutuhan
                height: 38,
              ),
            ),
            Text(title),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.blue),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Image.asset(
                      'assets/icon/app_icon.png',
                      width: 38, // kamu bisa ubah sesuai kebutuhan
                      height: 38,
                    ),
                  ),
                  const Text("Yuk Antri", style: TextStyle(color: Colors.white, fontSize: 24)),
                ],
              )
              // Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/dashboard');
              },
            ),
            ListTile(
              leading: const Icon(Icons.store),
              title: const Text('Merchants'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/merchants');
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Users'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/users');
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/profile');
              },
            ),
          ],
        ),
      ),
      body: child,
    );
  }
}
