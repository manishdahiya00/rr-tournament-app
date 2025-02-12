import 'package:app/screens/home_screen.dart';
import 'package:app/screens/sign_in_screen.dart';
import 'package:app/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String versionName = "";

  Future<void> _navigateBasedOnAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString("userId") ?? "";
    String securityToken = prefs.getString("securityToken") ?? "";

    final pakcageInfo = await Utils.getVersionInfo();
    setState(() {
      versionName = pakcageInfo["versionName"] ?? "";
    });

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
        if (response.data["version"] != versionName) {
          _showUpdateDialog();
          return;
        }

        await prefs.setString("phone", response.data["phone"].toString());
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
  }

  void _showUpdateDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Utils.darkBg,
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Utils.darkBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "New Update Available!",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () async {
                    final Uri uri = Uri.parse("https://www.google.com");

                    if (!await launchUrl(uri,
                        mode: LaunchMode.externalApplication)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Could not open the update link")),
                      );
                    }
                  },
                  child: const Text(
                    "Update",
                    style: TextStyle(color: Utils.primaryColor),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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
      backgroundColor: Utils.darkBg,
      body: SafeArea(
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              'assets/images/logo.png',
              width: Utils.screenWidth(context) * 0.4,
              height: Utils.screenWidth(context) * 0.4,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.error, size: 100, color: Utils.primaryColor),
            ),
          ),
        ),
      ),
    );
  }
}
