import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Utils {
  static double screenHeight(context) {
    return MediaQuery.sizeOf(context).height;
  }

  static double screenWidth(context) {
    return MediaQuery.sizeOf(context).width;
  }

  static String baseUrl =
      // "https://rr-tournament-api-production.up.railway.app/api/v1";
      "http://192.168.1.6:3000/api/v1";
  static String appName = "RR Config";

  static const Color darkBg = Color(0xff1A1C1E);
  static const Color primaryColor = Color(0xffFFCE3D);
  static const Color secondaryColor = Color.fromARGB(255, 62, 61, 63);

  static Future<Map<String, String>> getVersionInfo() async {
    PackageInfo info = await PackageInfo.fromPlatform();
    return {
      'versionName': info.version,
      'versionCode': info.buildNumber,
    };
  }

  static void showSnackbar(context,
      {String message = "", Color color = primaryColor}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
