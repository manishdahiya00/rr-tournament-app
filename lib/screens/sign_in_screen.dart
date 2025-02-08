import 'package:app/screens/home_screen.dart';
import 'package:app/screens/sign_up_screen.dart';
import 'package:app/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isSubmitting = false;

  void _navigateToHomeScreen() {
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _submitSignIn() async {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (!emailRegex.hasMatch(email)) {
      _showSnackbar("Invalid email address.");
      return;
    }

    if (password.length < 8) {
      _showSnackbar("Password must be at least 8 characters.");
      return;
    }

    if (mounted) setState(() => _isSubmitting = true);

    try {
      final dio = Dio();
      final response = await dio.post(
        "${Utils.baseUrl}/userSignin",
        data: {
          "email": email,
          "password": password,
        },
      );
      if (response.statusCode == 201 && response.data["status"] == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("name", response.data["name"].toString());
        await prefs.setString("email", response.data["email"].toString());
        await prefs.setString("userId", response.data["userId"].toString());
        await prefs.setString(
            "walletBalance", response.data["walletBalance"].toString());
        await prefs.setString(
            "securityToken", response.data["securityToken"].toString());
        _showSnackbar(response.data["message"]);
        String userId = prefs.getString("userId") ?? "";
        String securityToken = prefs.getString("securityToken") ?? "";

        if (userId.isEmpty || securityToken.isEmpty) {
          _navigateToLoginScreen();
          return;
        }

        try {
          final dio = Dio();
          final response = await dio.post(
            "${Utils.baseUrl}/appOpen",
            data: {"userId": userId, "securityToken": securityToken},
          );
          if (response.statusCode == 201 && response.data["status"] == 200) {
            await prefs.setString("name", response.data["name"].toString());
            await prefs.setString("email", response.data["email"].toString());
            await prefs.setString("phn1", response.data["phn1"].toString());
            await prefs.setString("phn2", response.data["phn2"].toString());
            await prefs.setString("tel1", response.data["tel1"].toString());
            await prefs.setString("tel2", response.data["tel2"].toString());
            await prefs.setString(
                "walletBalance", response.data["walletBalance"].toString());
            await prefs.setString(
                "bannerImage", response.data["bannerImage"].toString());
            _navigateToHomeScreen();
          } else {
            _navigateToLoginScreen();
          }
        } catch (e) {
          _navigateToLoginScreen();
        }
      } else {
        _showSnackbar(response.data["message"]);
        _navigateToLoginScreen();
      }
    } catch (e) {
      _navigateToLoginScreen();
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _navigateToLoginScreen() {
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignInScreen()),
      );
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      cursorColor: Colors.red,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        prefixIcon: Icon(icon),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: Utils.screenWidth(context) * 0.4,
                    height: Utils.screenWidth(context) * 0.4,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.error, size: 100, color: Colors.red),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Welcome Back",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Play Tournaments & Earn Rewards",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 10,
                        spreadRadius: 2,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildTextField(
                        controller: _emailController,
                        hintText: "Enter your email address",
                        icon: Icons.email,
                      ),
                      const SizedBox(height: 15),
                      _buildTextField(
                        controller: _passwordController,
                        hintText: "Enter your password",
                        icon: Icons.lock,
                        obscureText: true,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isSubmitting ? null : _submitSignIn,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: _isSubmitting
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Text("Sign In",
                                  style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpScreen()),
                          );
                        },
                        child: const Text(
                          "Don't have an account? Sign Up",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
