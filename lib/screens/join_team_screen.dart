import 'package:app/screens/sign_in_screen.dart';
import 'package:app/utils.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JoinTeamScreen extends StatefulWidget {
  final Map match;
  const JoinTeamScreen({super.key, required this.match});

  @override
  _JoinTeamScreenState createState() => _JoinTeamScreenState();
}

class _JoinTeamScreenState extends State<JoinTeamScreen> {
  String userId = "";
  String securityToken = "";
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _uidController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();

  bool _isSubmitting = false;

  Future<void> _submitJoinTeam() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("userId") ?? "0";
    securityToken = prefs.getString("securityToken") ?? "0";
    final name = _nameController.text.trim();
    final uid = _uidController.text.trim();
    final userName = _userNameController.text.trim();

    if (name.isEmpty || name.length < 3) {
      Utils.showSnackbar("Name must be at least 3 characters.");
      return;
    }

    if (uid.isEmpty || uid.length < 3) {
      Utils.showSnackbar("UID must be at least 3 characters.");
      return;
    }
    if (userName.isEmpty) {
      Utils.showSnackbar("Username is required.");
      return;
    }
    setState(() => _isSubmitting = true);

    try {
      final dio = Dio();
      final response = await dio.post(
        "${Utils.baseUrl}/joinTeam",
        data: {
          "uid": uid,
          "name": name,
          "username": userName,
          "matchId": widget.match["id"],
          "userId": userId,
          "securityToken": securityToken,
        },
      );
      if (response.statusCode == 201 && response.data["status"] == 200) {
        await prefs.setString(
            "walletBalance", response.data["walletBalance"].toString());

        Utils.showSnackbar(response.data["message"]);
      } else {
        Utils.showSnackbar(response.data["message"]);
      }
    } catch (e) {
      _navigateToLoginScreen();
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _navigateToLoginScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignInScreen()),
    );
  }

  Widget _buildTextField(
      {required TextEditingController controller,
      required String hintText,
      required IconData icon,
      bool obscureText = false,
      TextInputType type = TextInputType.name}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: type,
      style: const TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Utils.secondaryColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        prefixIcon: Icon(
          icon,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Join Team",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
        backgroundColor: Utils.darkBg,
      ),
      backgroundColor: Utils.darkBg,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Join a Team",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 10),
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
                      _buildTextField(
                        controller: _nameController,
                        hintText: "Enter your name ",
                        icon: Icons.group,
                      ),
                      const SizedBox(height: 15),
                      _buildTextField(
                          controller: _uidController,
                          hintText: "Enter UID ",
                          type: TextInputType.number,
                          icon: Icons.group),
                      const SizedBox(height: 15),
                      _buildTextField(
                          controller: _userNameController,
                          hintText: "Enter username",
                          icon: Icons.person),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isSubmitting ? null : _submitJoinTeam,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            backgroundColor: Utils.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: _isSubmitting
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Text("Join Team",
                                  style: TextStyle(color: Colors.black)),
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
