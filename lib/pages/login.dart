import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:testing/widgets/double_back_to_exit.dart';
import 'package:testing/providers/auth_provider.dart';

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
  bool _isLoading = false;

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

  void _login() {
    // TODO: implement login logic
    print("Email: ${_emailController.text}");
    print("Password: ${_passwordController.text}");
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
                Padding(
                  padding: const EdgeInsets.only(top: 24.0, left: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Selamat Datang!",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text("Aplikasi Antrian Digital"),
                      const SizedBox(height: 15),
                      ElevatedButton.icon(
                        onPressed: _nextPage,
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text("Selanjutnya"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF8080),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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
                Padding(
                  padding: const EdgeInsets.only(top: 24.0, left: 16.0),
                  // jarak dari atas & kiri
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: _previousPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF8080),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.all(12),
                          shape: const CircleBorder(), // bikin tombolnya bulat
                        ),
                        child: const Icon(Icons.arrow_back),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Sign in",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30),
                      TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: "Email",
                          prefixIcon: Icon(Icons.email),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: "Password",
                          prefixIcon: Icon(Icons.lock),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(value: true, onChanged: (_) {}),
                              const Text("Remember Me"),
                            ],
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text("Forgot Password?"),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed:
                              _isLoading
                                  ? null
                                  : () async {
                                    setState(() => _isLoading = true);

                                    final auth = Provider.of<AuthProvider>(
                                      context,
                                      listen: false,
                                    );
                                    final resultLogin = await auth.login(
                                      _emailController.text,
                                      _passwordController.text,
                                    );

                                    setState(() => _isLoading = false);

                                    if (resultLogin['status'] == true) {
                                      Navigator.pushReplacementNamed(
                                        context,
                                        '/dashboard',
                                      );
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        // SnackBar(
                                        //   content: Text(resultLogin['message']),
                                        // ),
                                        SnackBar(
                                          content: Text(resultLogin['message'] ?? 'Login gagal'),
                                        ),

                                      );
                                    }
                                  },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF8080),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child:
                              _isLoading
                                  ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                  : const Text("Login"),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {},
                        child: const Text("Don’t have an account? Sign up"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Wave Clip untuk bagian atas
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.75);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height * 0.75,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
