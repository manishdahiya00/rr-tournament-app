import 'package:app/utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  String phn1 = "";
  String phn2 = "";
  String tel1 = "";
  String tel2 = "";
  void getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      phn1 = prefs.getString("phn1") ?? "";
      phn2 = prefs.getString("phn2") ?? "";
      tel1 = prefs.getString("tel1") ?? "";
      tel2 = prefs.getString("tel2") ?? "";
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Utils.darkBg,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Help and Support",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
        backgroundColor: Utils.darkBg,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text(
                "Contact Information",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                "Phone: $phn1\nAlternative Phone: +91 $phn2",
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                "Telegram: @$tel1\nAlternative Telegram: @$tel2",
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
