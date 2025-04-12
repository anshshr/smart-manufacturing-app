import 'package:flutter/material.dart';
import 'package:smart_manufacturing/services/multilingual_chat_bot/pages/record_audio.dart';
import 'package:smart_manufacturing/widgets/AdminBottomNav.dart';
import 'package:smart_manufacturing/widgets/bottom_nav_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:smart_manufacturing/pages/admin/pages/inventory_assets_map.dart';
import 'package:smart_manufacturing/pages/auth/pages/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "smart manufacturing",
      home:  AdminBottomNavBar(), // Change this to your desired initial page
    ),
  );
}
