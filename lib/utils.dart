import 'package:flutter/material.dart';

class Utils {
  static double screenHeight(context) {
    return MediaQuery.sizeOf(context).height;
  }

  static double screenWidth(context) {
    return MediaQuery.sizeOf(context).width;
  }

  static String baseUrl =
      "https://rr-tournament-api-production.up.railway.app/api/v1";
  static String appName = "RR Config";
}
