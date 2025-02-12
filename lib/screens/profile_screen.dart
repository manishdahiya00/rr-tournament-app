import 'package:app/screens/help_screen.dart';
import 'package:app/screens/privacy_policy.dart';
import 'package:app/screens/sign_in_screen.dart';
import 'package:app/screens/terms_screen.dart';
import 'package:app/screens/wallet_screen.dart';
import 'package:app/utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String phone = "";
  String walletBalance = "";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("userId");
    prefs.remove("securityToken");
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const SignInScreen()));
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      phone = prefs.getString("phone") ?? "-";
      walletBalance = prefs.getString("walletBalance") ?? "0";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Utils.darkBg,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          Utils.appName,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Utils.darkBg,
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const WalletScreen()));
            },
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Utils.primaryColor,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  const Icon(Icons.monetization_on, color: Colors.black),
                  const SizedBox(width: 5),
                  Text(
                    walletBalance,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(
                    'assets/images/profile.png',
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      phone,
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              'Account Settings',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.lock, color: Colors.white),
              title: const Text(
                'Privacy Policy',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PrivacyPolicyScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.gavel, color: Colors.white),
              title: const Text(
                'Terms and Conditions',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TermsScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.help, color: Colors.white),
              title: const Text(
                'Help and Support',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HelpScreen()));
              },
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: Utils.screenWidth(context),
              child: ElevatedButton(
                onPressed: () {
                  logout();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Utils.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text(
                  'Logout',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
