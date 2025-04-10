import 'package:testing/pages/login.dart';
import 'package:testing/pages/merchants.dart';
import 'package:testing/pages/news.dart';
import 'package:testing/pages/splash_screen.dart';
import 'package:testing/pages/dashboard.dart';
import 'package:testing/pages/profile.dart';
import 'package:testing/pages/users.dart';
final routes = {
  '/': (context) => const SplashPage(),
  '/dashboard': (context) => const DashboardPage(),
  '/profile': (context) => const ProfilePage(),
  '/merchants': (context) => const MerchantsPage(),
  '/users': (context) => const UsersPage(),
  '/news': (context) => const NewsPage(),
  '/login': (context) => const LoginPage(),
};
