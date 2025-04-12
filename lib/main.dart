import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:smart_manufacturing/pages/auth/pages/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "smart manufacturing",
      home: SplashScreen(), 
    ),
  );
}
