import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:smart_manufacturing/widgets/AdminBottomNav.dart';
import 'package:smart_manufacturing/pages/auth/service/auth_service.dart';
import 'package:smart_manufacturing/widgets/bottom_nav_bar.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthService _authService = AuthService();

  void _navigateToDashboard(BuildContext context, bool isAdmin) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => isAdmin ? AdminBottomNavBar() : BottomNavBar(),
      ),
    );
  }

  void _showError(BuildContext context, String error) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fullscreen Background Image
          SizedBox.expand(
            child: Stack(
              children: [
                Image.asset(
                  "assets/images/splash.png",
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(color: Colors.black.withOpacity(0)),
                ),
              ],
            ),
          ),

          // Top Right Text
          Positioned(
            top: 50,
            right: 18,
            child: Container(
              width: 250,
              child: Text(
                "Enhancing factory efficiency with real-time predictive maintenance.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ),

          // Main Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome to",
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      "Smart Sense",
                      style: TextStyle(
                        fontSize: 44,
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "A predictive maintenance solution to minimize downtime and improve efficiency.",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Admin Button - Direct Google Sign-In
                    ElevatedButton(
                      onPressed: () {
                        _authService.googleSignInWithRole(
                          'admin',
                          () => _navigateToDashboard(context, true),
                          (error) => _showError(context, error),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.admin_panel_settings, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            "Sign In as Admin",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Maintenance Worker Button - Direct Google Sign-In
                    ElevatedButton(
                      onPressed: () {
                        _authService.googleSignInWithRole(
                          'worker',
                          () => _navigateToDashboard(context, false),
                          (error) => _showError(context, error),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.engineering, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            "Sign In as Worker",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
