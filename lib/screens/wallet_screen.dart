import 'package:app/screens/home_screen.dart';
import 'package:app/screens/qr_codes_screen.dart';
import 'package:app/screens/sign_in_screen.dart';
import 'package:app/utils.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  String walletBalance = "0";
  String userId = "0";
  String securityToken = "0";
  String phn1 = "0";
  String phn2 = "0";
  String tel1 = "0";
  String tel2 = "0";

  @override
  void initState() {
    super.initState();

    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      walletBalance = prefs.getString('walletBalance') ?? "0";
      userId = prefs.getString('userId') ?? "0";
      securityToken = prefs.getString('securityToken') ?? "0";
      phn1 = prefs.getString('phn1') ?? "0";
      phn2 = prefs.getString('phn2') ?? "0";
      tel1 = prefs.getString('tel1') ?? "0";
      tel2 = prefs.getString('tel2') ?? "0";
    });
  }

  // Show the withdrawal form as a popup
  void _showWithdrawPopup() {
    final TextEditingController upiController = TextEditingController();
    final TextEditingController mobileController = TextEditingController();
    final TextEditingController amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Utils.darkBg, // Transparent background for dialog
          child: Container(
            width: MediaQuery.of(context).size.width, // Full width
            padding: const EdgeInsets.all(20), // Add some padding if necessary
            decoration: BoxDecoration(
              color: Utils.darkBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize:
                  MainAxisSize.min, // Make sure the dialog takes minimal height
              children: [
                const Text(
                  "Withdraw Funds",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: upiController,
                  cursorColor: Colors.white,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Enter UPI Id",
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Utils.secondaryColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: mobileController,
                  cursorColor: Colors.white,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Enter mobile number",
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Utils.secondaryColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: amountController,
                  cursorColor: Colors.white,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Enter amount",
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Utils.secondaryColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the popup
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        final upiId = upiController.text.trim();
                        final mobileNumber = mobileController.text.trim();
                        final amount =
                            double.tryParse(amountController.text.trim());

                        if (upiId.isEmpty ||
                            mobileNumber.isEmpty ||
                            amount == null ||
                            amount <= 0) {
                          Utils.showSnackbar(context,
                              message: "Please fill all fields correctly.");
                        } else {
                          _submitWithdrawal(upiId, mobileNumber, amount, userId,
                              securityToken);
                          Navigator.of(context).pop(); // Close the popup
                        }
                      },
                      child: const Text(
                        "Submit",
                        style: TextStyle(color: Utils.primaryColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDepositPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Dialog(
            backgroundColor: Utils.darkBg, // Transparent background for dialog
            child: Container(
              width: MediaQuery.of(context).size.width, // Full width
              padding:
                  const EdgeInsets.all(20), // Add some padding if necessary
              decoration: BoxDecoration(
                color: Utils.darkBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize
                    .min, // Make sure the dialog takes minimal height
                children: [
                  const Text(
                    "Deposit Funds",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    '''
          Important Notice
          To ensure a secure and seamless transaction experience, please note the following requirements:

          1. Payment Confirmation: Please scan one of the provided codes to complete your payment.
          2. Verification: For security purposes, kindly send a screenshot of your payment confirmation to our support team via Telegram or WhatsApp. This step is mandatory to verify your transaction.
          3. Wallet Update: To update your wallet, please provide your Gmail address. Please note that wallet updates may take between 2 to 24 hours to process.

          Important Security Notice
          - Any attempts to submit fake payment screenshots or proof may result in permanent ban from our application.

          Thank you for your cooperation and understanding in maintaining the security and integrity of our platform.

          ''',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the popup
                        },
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const QrCodesScreen())); // Close the popup
                        },
                        child: const Text(
                          "Continue",
                          style: TextStyle(
                            color: Utils.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _navigateToLoginScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignInScreen()),
    );
  }

  // Submit withdrawal request to API
  Future<void> _submitWithdrawal(String upiId, String mobileNumber,
      double amount, String userId, String securityToken) async {
    try {
      final dio = Dio();
      final response = await dio.post(
        "${Utils.baseUrl}/redeem",
        data: {
          "userId": userId,
          "securityToken": securityToken,
          "upiId": upiId,
          "mobileNumber": mobileNumber,
          "amount": amount,
        },
      );

      if (response.statusCode == 201 && response.data["status"] == 200) {
        Utils.showSnackbar(context, message: response.data["message"]);
      } else {
        Utils.showSnackbar(context, message: response.data["message"]);
      }
    } catch (e) {
      Utils.showSnackbar(context, message: "Something went wrong. Try again.");
      _navigateToLoginScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Utils.darkBg,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()));
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
          title: Text(
            Utils.appName,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w500),
          ),
          backgroundColor: Utils.darkBg,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Material(
                  color: Utils.secondaryColor,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text(
                          'Your Wallet Balance',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Amount: ₹${walletBalance.toString()}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Utils.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Buttons for Withdraw and Deposit
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          _showDepositPopup();
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          backgroundColor: Utils.primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text("Deposit",
                            style: TextStyle(color: Colors.black)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _showWithdrawPopup, // Show withdrawal popup
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          backgroundColor: Utils.primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text("Withdraw",
                            style: TextStyle(color: Colors.black)),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Align(
                      alignment: Alignment.center,
                      child: Text(
                        '''AFTER PAYMENT YOU HAVE TO SEND SCREENSHOT OF PAYMENT WITH YOUR GMAIL ( GMAIL THAT YOU GIVE IN LOGIN PAGE ). SEND SCREENSHOT ON TELEGRAM OR WHATSAPP TO UPDATE YOUR WALLET

                             IMPORTANT NOTICE

                    IN CASE OF FAKE PAYMENT SCREENSHOT OR  TRYING TO SCAM WITH US CAN BE THE REASON OF PERMANENT DEVICE BAN.''',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      '*********************',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Telegram Username :',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        tel1,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Utils.primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        tel2,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Utils.primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Align(
                      alignment: Alignment.center,
                      child: Text(
                        'WhatsApp Number :',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        phn1,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Utils.primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        phn2,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Utils.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
