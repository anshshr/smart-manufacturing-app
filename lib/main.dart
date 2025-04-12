import 'package:flutter/material.dart';
import 'package:smart_manufacturing/services/multilingual_chat_bot/pages/record_audio.dart';
import 'package:smart_manufacturing/widgets/bottom_nav_bar.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "smart manufacturing",
      home: BottomNavBar(),
    ),
  );
}
