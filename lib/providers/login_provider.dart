import 'package:flutter/material.dart';
import 'package:flutter_to_do/view/home.dart' show HomeScreen;
import 'package:shared_preferences/shared_preferences.dart';

class LoginProvider extends ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String? emailError;
  String? passwordError;

  bool _obscurePassword = true;
  bool get obscurePassword => _obscurePassword;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  bool validateInputs() {
    final email = emailController.text.trim();
    final password = passwordController.text;

    emailError = null;
    passwordError = null;

    if (email.isEmpty || !email.contains('@')) {
      emailError = 'Enter a valid email';
    }

    if (password.isEmpty || password.length < 6) {
      passwordError = 'Password must be at least 6 characters';
    }

    notifyListeners();
    return emailError == null && passwordError == null;
  }

  Future<void> login(context) async {
    if (!validateInputs()) return;
    _isLoading = true;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', emailController.text.trim());
    await prefs.setString('password', passwordController.text);
    if (emailError == null && passwordError == null) {
      Future.delayed(const Duration(seconds: 1), () {
        _isLoading = false;
        notifyListeners();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Login Successful!")));
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
