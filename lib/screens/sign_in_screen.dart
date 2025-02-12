import 'package:app/screens/home_screen.dart';
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
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _referCodeController = TextEditingController();
  bool _isSubmitting = false;
  bool _otpSent = false;
  String versionName = "";
  String versionCode = "";

  Future<void> _sendOTP() async {
    final phoneRegex = RegExp(r'^\d{10}$');
    final phoneNumber = _phoneController.text.trim();
    final referCode = _referCodeController.text.trim();

    final pakcageInfo = await Utils.getVersionInfo();
    versionName = pakcageInfo["versionName"] ?? "";
    versionCode = pakcageInfo["versionCode"] ?? "";

    if (!phoneRegex.hasMatch(phoneNumber)) {
      Utils.showSnackbar(context,
          message: "Invalid phone number. Please enter a 10-digit number.");
      return;
    }

    if (mounted) setState(() => _isSubmitting = true);

    try {
      final dio = Dio();
      final response = await dio.post(
        "${Utils.baseUrl}/auth",
        data: {
          "phone": phoneNumber,
          "referralCode": referCode,
          "versionName": versionName,
          "versionCode": versionCode
        },
      );

      if (response.statusCode == 201 && response.data["status"] == 200) {
        Utils.showSnackbar(context, message: "OTP sent successfully!");
        setState(() => _otpSent = true);
      } else {
        Utils.showSnackbar(context,
            message: response.data["message"] ?? "Failed to send OTP.");
      }
    } catch (e) {
      Utils.showSnackbar(
        context,
        message: "Something went wrong. Please try again.",
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _verifyOTP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final otp = _otpController.text.trim();
    if (otp.length != 6) {
      Utils.showSnackbar(context, message: "Please enter a valid 6-digit OTP.");
      return;
    }

    if (mounted) setState(() => _isSubmitting = true);

    try {
      final dio = Dio();
      final response = await dio.post(
        "${Utils.baseUrl}/verifyOtp",
        data: {"phone": _phoneController.text.trim(), "otp": otp},
      );
      if (response.statusCode == 201 && response.data["status"] == 200) {
        await prefs.setString("userId", response.data["userId"].toString());
        await prefs.setString(
            "securityToken", response.data["securityToken"].toString());
        await prefs.setString("phone", response.data["phone"].toString());
        await prefs.setString("phn1", response.data["phn1"].toString());
        await prefs.setString("phn2", response.data["phn2"].toString());
        await prefs.setString("tel1", response.data["tel1"].toString());
        await prefs.setString("tel2", response.data["tel2"].toString());
        await prefs.setString(
            "referCode", response.data["referCode"].toString());
        await prefs.setString(
            "walletBalance", response.data["walletBalance"].toString());
        await prefs.setString(
            "bannerImage", response.data["bannerImage"].toString());
        Utils.showSnackbar(context, message: "Login successful!");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        Utils.showSnackbar(
          context,
          message: response.data["message"] ?? "OTP verification failed.",
        );
      }
    } catch (e) {
      Utils.showSnackbar(
        context,
        message: "Something went wrong. Please try again.",
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Utils.darkBg,
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
                    errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.error,
                        size: 100,
                        color: Utils.primaryColor),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Sign In",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Utils.darkBg,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                        color: Utils.secondaryColor,
                        blurRadius: 10,
                        spreadRadius: 2,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _phoneController,
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.phone,
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          hintText: "Enter your phone number",
                          hintStyle: const TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: Utils.secondaryColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          enabled: !_otpSent,
                          prefixIcon: const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Text(
                              "+91",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _referCodeController,
                        style: const TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                            hintText: "Refer Code (Optional)",
                            hintStyle: const TextStyle(color: Colors.grey),
                            filled: true,
                            fillColor: Utils.secondaryColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            enabled: !_otpSent,
                            prefixIcon: const Icon(
                              Icons.share,
                              color: Colors.white,
                            )),
                      ),
                      const SizedBox(height: 20),
                      Visibility(
                        visible: _otpSent,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _otpController,
                              style: const TextStyle(color: Colors.white),
                              keyboardType: TextInputType.number,
                              cursorColor: Colors.white,
                              decoration: InputDecoration(
                                hintText: "Enter OTP",
                                hintStyle: const TextStyle(color: Colors.grey),
                                filled: true,
                                fillColor: Utils.secondaryColor,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                prefixIcon: const Icon(
                                  Icons.lock,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isSubmitting
                              ? null
                              : (_otpSent ? _verifyOTP : _sendOTP),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            backgroundColor: Utils.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: _isSubmitting
                              ? const CircularProgressIndicator(
                                  color: Utils.primaryColor)
                              : Text(_otpSent ? "Verify OTP" : "Send OTP",
                                  style: const TextStyle(color: Colors.black)),
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
