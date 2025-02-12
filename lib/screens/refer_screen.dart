import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For copying to clipboard
import 'package:app/screens/wallet_screen.dart';
import 'package:app/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReferScreen extends StatefulWidget {
  const ReferScreen({super.key});

  @override
  State<ReferScreen> createState() => _ReferScreenState();
}

class _ReferScreenState extends State<ReferScreen> {
  String referCode = "-";
  String walletBalance = "-";

  void loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      referCode = prefs.getString('referCode') ?? "-";
      walletBalance = prefs.getString('walletBalance') ?? "0";
    });
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: referCode));
    Utils.showSnackbar(context, message: "Copied to Clipboard");
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
        backgroundColor: Utils.darkBg,
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WalletScreen()),
              );
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
      backgroundColor: Utils.darkBg,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/refer.png",
                height: Utils.screenHeight(context) * 0.3,
                width: Utils.screenHeight(context) * 0.4,
              ),
              const Text(
                "Refer & Earn Rewards!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Referral Code Card
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      referCode,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy, color: Colors.white),
                      onPressed: _copyToClipboard,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Steps/Rules Section
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "How it Works:",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              _buildStep("1. Share your referral code with friends."),
              const SizedBox(
                height: 10,
              ),
              _buildStep("2. Your friend signs up using your code."),
              const SizedBox(
                height: 10,
              ),
              _buildStep("3. Both of you earn rewards!"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: Utils.primaryColor, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
