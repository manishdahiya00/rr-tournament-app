import 'package:app/screens/profile_screen.dart';
import 'package:app/screens/sign_in_screen.dart';
import 'package:app/screens/tournaments_screen.dart';
import 'package:app/screens/wallet_screen.dart';
import 'package:app/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeContent(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.black.withOpacity(0.7),
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  String walletBalance = "";
  String userId = "";
  String securityToken = "";
  String bannerImage = "";
  late Future<List<dynamic>> _categoriesFuture;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = _fetchCategories();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      walletBalance = prefs.getString("walletBalance") ?? "0";
      bannerImage = prefs.getString("bannerImage") ?? "";
    });
  }

  Future<List<dynamic>> _fetchCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("userId") ?? "0";
    securityToken = prefs.getString("securityToken") ?? "0";

    try {
      final response = await Dio().post(
        "${Utils.baseUrl}/allCategories",
        data: {"userId": userId, "securityToken": securityToken},
      );
      if (response.statusCode == 201 && response.data["status"] == 200) {
        await prefs.setString(
            "walletBalance", response.data["walletBalance"].toString());
        return response.data["categories"] ?? [];
      } else {
        return [];
      }
    } catch (e) {
      _navigateToLoginScreen();
      return [];
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          Utils.appName,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.red,
        elevation: 1,
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
                color: Colors.white,
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
      backgroundColor: Colors.white,
      body: FutureBuilder<List<dynamic>>(
        future: _categoriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.red),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("No categories available."),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    bannerImage,
                    width: Utils.screenWidth(context),
                    height: Utils.screenHeight(context) * 0.20,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.error, size: 100, color: Colors.red),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Tournaments",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final category = snapshot.data![index];

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                TournamentsScreen(categoryId: category["id"]),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(10)),
                              child: Image.network(
                                category['image_url'] ?? "",
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 150,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.error,
                                        size: 50, color: Colors.red),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                category["title"] ?? "No Title",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
