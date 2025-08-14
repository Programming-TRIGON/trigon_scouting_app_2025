import 'package:flutter/material.dart';

import '../../utilities/firebase_utilities.dart';

class LoginProvider extends ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool hidePassword = true;

  void togglePasswordVisibility() {
    hidePassword = !hidePassword;
    notifyListeners();
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r"^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$");
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    return null;
  }

  Future<void> signIn(BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Invalid password or email, or not connected to the Internet.',
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final user = await FirebaseUtilities.logInWithEmailAndPassword(
      emailController.text,
      passwordController.text,
    );

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Invalid password or email, or not connected to the Internet.',
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    notifyListeners();

    // Navigator.pushReplacement(
    //   context,
    //   MaterialDesignFactory.createModernRoute(const HomeScreen()),
    // );
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
}
