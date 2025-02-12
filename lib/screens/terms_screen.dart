import 'package:app/utils.dart';
import 'package:flutter/material.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Utils.darkBg,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Terms and Conditions",
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
                "These terms govern the use of our application. By using our services, you agree to abide by these terms.",
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 16),
              Text(
                "2. User Responsibilities",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(height: 8),
              Text(
                "Users must ensure they use our services responsibly and do not engage in prohibited activities.",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
