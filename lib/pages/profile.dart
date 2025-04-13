import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:testing/widgets/double_back_to_exit.dart';
import 'package:testing/layouts/main.dart';
import 'dart:convert';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isDarkMode = false; // State untuk dark mode
  Map<String, dynamic>? user;

  @override
  void initState() {
    super.initState();
    _loadDarkModePreference();
    loadUSer();
  }

  Future<void> loadUSer() async {
    const storage = FlutterSecureStorage();
    final userJson = await storage.read(key: 'user');
    if (userJson != null) {
      final userData = jsonDecode(userJson);
      setState(() {
        user = userData['data'];
      });
    }
  }

  // Fungsi untuk memuat preferensi dark mode (contoh, bisa dari shared preferences)
  void _loadDarkModePreference() {
    // Misalnya, ambil dari shared preferences atau provider
    setState(() {
      _isDarkMode = false; // Nilai default
    });
  }

  // Fungsi untuk mengubah dark mode
  void _toggleDarkMode(bool value) {
    setState(() {
      _isDarkMode = value;
      // Simpan preferensi dark mode (misalnya ke shared preferences)
      // Anda bisa menggunakan provider atau shared preferences untuk ini
    });
  }

  @override
  Widget build(BuildContext context) {
    var userName = user?['name'] ?? 'Unknown User';
    var email = user?['email'] ?? 'No email provided';

    return DoubleBackToExitWrapper(
      child: MainLayout(
        title: 'Profile',
        titleIcon: const Icon(Icons.person),
        child: Column(
          children: [
            Container(
              color: const Color(0xFFE6E6FA), // Warna latar belakang header
              padding: const EdgeInsets.only(bottom: 20, top: 20),
              child: Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: const NetworkImage(
                    'https://github.com/iyanrinri.png', // Ganti dengan URL gambar profil
                  ),
                  onBackgroundImageError: (exception, stackTrace) {
                    // Jika gambar gagal dimuat, tampilkan placeholder
                    const Icon(Icons.person, size: 50);
                  },
                  child: const Icon(Icons.person, size: 50),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow('Mail', email),
                  const Divider(height: 32),
                  // Dark Mode Switch
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.nightlight_round, size: 20),
                            SizedBox(width: 8),
                            Text('Dark mode', style: TextStyle(fontSize: 16)),
                          ],
                        ),
                        Switch(value: _isDarkMode, onChanged: _toggleDarkMode),
                      ],
                    ),
                  ),
                  // const Divider(),
                  // // Profile Details
                  // _buildMenuItem(Icons.person, 'Profile details', () {
                  //   // Navigasi ke halaman detail profil
                  //   Navigator.pushNamed(context, '/profile-details');
                  // }),
                  const Divider(),
                  // Settings
                  _buildMenuItem(Icons.settings, 'Settings', () {
                    // Navigasi ke halaman pengaturan
                    // Navigator.pushNamed(context, '/settings');
                  }),
                  const Divider(),
                  // Log out
                  _buildMenuItem(Icons.logout, 'Log out', () async {
                    // Logika untuk logout
                    const storage = FlutterSecureStorage();
                    await storage.delete(key: 'token');
                    await storage.delete(key: 'user');
                    if (mounted) {
                      Navigator.pop(context);
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/login',
                        (route) => false,
                      );
                    }
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk baris informasi (Mail)
  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, color: Colors.grey)),
        Text(value, style: const TextStyle(fontSize: 16, color: Colors.black)),
      ],
    );
  }

  // Widget untuk item menu (Profile details, Settings, Log out)
  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, size: 20),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      onTap: onTap,
    );
  }
}
