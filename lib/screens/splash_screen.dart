import 'package:app/screens/home_screen.dart';
import 'package:app/screens/sign_in_screen.dart';
import 'package:app/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> _navigateBasedOnAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
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
        print(prefs.getString("phn1"));
        _navigateToHomeScreen();
      } else {
        _navigateToLoginScreen();
      }
    } catch (e) {
      _navigateToLoginScreen();
    }
  }

  void _navigateToHomeScreen() {
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
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

  @override
  void initState() {
    super.initState();
    _navigateBasedOnAuth();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/images/logo.png',
                  width: Utils.screenWidth(context) * 0.4,
                  height: Utils.screenWidth(context) * 0.4,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.error, size: 100, color: Colors.red),
                ),
              ),
            ),
            Positioned(
              bottom: Utils.screenHeight(context) * 0.02,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Powered with ',
                      style: TextStyle(fontSize: 14, color: Colors.black)),
                  const Icon(Icons.favorite, color: Colors.red, size: 14),
                  Text(' by ${Utils.appName}',
                      style:
                          const TextStyle(fontSize: 14, color: Colors.black)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
