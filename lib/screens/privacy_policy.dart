import 'package:app/utils.dart';
import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Utils.darkBg,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Privacy Policy",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
        backgroundColor: Utils.darkBg,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "1. Introduction",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(height: 8),
              Text(
                "Welcome to our app. Your privacy is important to us. This policy explains how we collect, use, and protect your information.",
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 16),
              Text(
                "2. Information We Collect",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(height: 8),
              Text(
                "We collect personal information such as your name, email address, and payment details when you use our services.",
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 16),
              Text(
                "3. How We Use Your Information",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(height: 8),
              Text(
                "Your information is used to provide and improve our services, personalize user experience, and ensure security.",
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 16),
              Text(
                "4. Data Security",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(height: 8),
              Text(
                "We implement security measures to protect your data from unauthorized access and misuse.",
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 16),
              Text(
                "5. Third-Party Services",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(height: 8),
              Text(
                "We may share your data with trusted third-party services to enhance our offerings, always ensuring your privacy.",
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 16),
              Text(
                "6. Your Rights",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(height: 8),
              Text(
                "You have the right to access, update, or delete your personal data. Contact us for any privacy-related concerns.",
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 16),
              Text(
                "7. Changes to This Policy",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(height: 8),
              Text(
                "We may update our privacy policy from time to time. Any changes will be posted on this page.",
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
