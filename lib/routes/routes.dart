import 'package:testing/pages/login.dart';
import 'package:testing/pages/splash_screen.dart';
import 'package:testing/pages/dashboard.dart';
import 'package:testing/pages/profile.dart';
final routes = {
  '/': (context) => const SplashPage(),
  '/dashboard': (context) => const DashboardPage(),
  '/profile': (context) => const ProfilePage(),
  '/login': (context) => const LoginPage(),
};
