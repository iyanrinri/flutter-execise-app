import 'package:flutter/material.dart';

import 'package:testing/widgets/double_back_to_exit.dart';
import 'package:testing/widgets/screens/welcome_slide.dart';
import 'package:testing/widgets/auth/login_form.dart';
import 'package:testing/widgets/buttons/back_button_header.dart';
import 'package:testing/widgets/clipper/wave_clipper.dart';
import 'package:testing/helpers/user_helper.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _rememberController = TextEditingController();
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    UserHelper.checkUser(context);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _rememberController.dispose();
    super.dispose();
  }

  void _nextPage() {
    _pageController.animateToPage(
      1,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _previousPage() {
    _pageController.animateToPage(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DoubleBackToExitWrapper(
      child: Scaffold(
        backgroundColor: const Color(0xFFFFB3B3),
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            // Page 1 - Welcome
            Stack(
              children: [
                Positioned.fill(
                  child: ClipPath(
                    clipper: WaveClipper(),
                    child: Container(color: Colors.white),
                  ),
                ),
                WelcomeSlide(onNext: _nextPage),
              ],
            ),

            // Page 2 - Login
            Stack(
              children: [
                Positioned.fill(
                  child: ClipPath(
                    clipper: WaveClipper(),
                    child: Container(color: Colors.white),
                  ),
                ),
                BackButtonHeader(onBack: _previousPage),
                const LoginForm(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}