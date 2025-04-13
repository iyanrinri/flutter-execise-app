import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:testing/helpers/user_helper.dart';
import 'package:testing/providers/auth_provider.dart';
import 'package:local_auth/local_auth.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = LocalAuthentication();
  final _storage = const FlutterSecureStorage();
  bool _isLoading = false;
  bool _rememberMe = false;
  String? _savedToken;

  @override
  void initState() {
    super.initState();
    _loadSavedToken();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  void _loadSavedToken() async {
    final token = await _storage.read(key: 'access_token');
    if (mounted) {
      setState(() {
        _savedToken = token;
      });
    }
  }

  void _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (!UserHelper.isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email tidak valid')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final auth = Provider.of<AuthProvider>(context, listen: false);
    final result = await auth.login(
      email,
      password, _rememberMe
    );

    setState(() => _isLoading = false);

    if (result['status'] == true) {
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Login gagal')),
      );
    }
  }


  Future<void> _loginWithFingerprint() async {
    final canAuth = await _auth.canCheckBiometrics;
    if (!canAuth) return;

    final didAuth = await _auth.authenticate(
      localizedReason: 'Login with fingerprint',
      options: const AuthenticationOptions(biometricOnly: true),
    );

    if (didAuth) {
      // Cek apakah ada token/login data tersimpan
      _savedToken = await _storage.read(key: 'access_token');
      if (_savedToken != null) {
        await _storage.write(key: 'token', value: _savedToken);
        // Bisa juga cek validitas token ke server
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No saved login. Please login with email & password.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Sign in",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
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
                  Checkbox(value: _rememberMe, onChanged: (value) {
                    setState(() {
                      _rememberMe = value ?? false;
                    });
                  }),
                  const Text("Remember Me"),
                ],
              ),
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Forgot Password is Coming Soon ! :)"),
                      duration: Duration(seconds: 3),
                    ),
                  );
                },
                child: const Text("Forgot Password?"),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF8080),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
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
          const SizedBox(height: 10),
          // Tombol Fingerprint
          if (_savedToken != null) IconButton(
            icon: const Icon(Icons.fingerprint, size: 40),
            onPressed: _loginWithFingerprint,
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Sign Up is Coming Soon ! :)"),
                  duration: Duration(seconds: 3),
                ),
              );
            },
            child: const Text("Don’t have an account? Sign up"),
          ),
        ],
      ),
    );
  }
}
