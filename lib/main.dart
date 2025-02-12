import 'package:app/screens/splash_screen.dart';
import 'package:app/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Utils.appName,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Utils.darkBg),
        useMaterial3: true,
      ),
      home: const SafeArea(child: SplashScreen()),
    );
  }
}
