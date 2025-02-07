import 'package:flutter/material.dart';

class Utils {
  static double screenHeight(context) {
    return MediaQuery.sizeOf(context).height;
  }

  static double screenWidth(context) {
    return MediaQuery.sizeOf(context).width;
  }

  static String baseUrl = "http://192.168.1.6:3000/api/v1";
  static String appName = "RR Config";
}
