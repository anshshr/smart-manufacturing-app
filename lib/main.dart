import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:smart_manufacturing/firebase_options.dart';
import 'package:smart_manufacturing/services/multilingual_chat_bot/pages/record_audio.dart';
import 'package:smart_manufacturing/widgets/AdminBottomNav.dart';
import 'package:smart_manufacturing/widgets/bottom_nav_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:smart_manufacturing/pages/auth/pages/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize("4ac56053-1ccf-478e-8446-8ac566e01109");
  OneSignal.Notifications.requestPermission(true);
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "smart manufacturing",
      home: SplashScreen(), 
    ),
  );
}
