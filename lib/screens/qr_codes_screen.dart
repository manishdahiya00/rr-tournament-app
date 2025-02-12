import 'package:app/screens/wallet_screen.dart';
import 'package:app/utils.dart';
import 'package:flutter/material.dart';

class QrCodesScreen extends StatelessWidget {
  const QrCodesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Utils.darkBg,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const WalletScreen()));
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        title: Text(
          Utils.appName,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Utils.darkBg,
      ),
      body: SingleChildScrollView(
          child: SizedBox(
        height: Utils.screenHeight(context),
        width: Utils.screenWidth(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 40,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                "assets/images/rordev.png",
                height: Utils.screenHeight(context) * 0.3,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                "assets/images/harsh.png",
                height: Utils.screenHeight(context) * 0.3,
              ),
            ),
          ],
        ),
      )),
    );
  }
}
