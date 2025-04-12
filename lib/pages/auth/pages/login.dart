import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:smart_manufacturing/widgets/AdminBottomNav.dart';
import 'package:smart_manufacturing/pages/auth/service/auth_service.dart';
import 'package:smart_manufacturing/widgets/bottom_nav_bar.dart';


class Login extends StatelessWidget {
  const Login({super.key});

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
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [Colors.green.shade100, Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )),
            ),
          ),
          // Main Content
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: const EdgeInsets.all(16),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.green.shade400,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "🌾 HarvestScore",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "Empowering farmers with fair and tailored credit options by leveraging non-traditional data sources.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 30),
                          // Admin Login Button
                          ElevatedButton.icon(
                            onPressed: () {
                              AuthService().googleSignInWithRole(
                                'admin',
                                () => _navigateToDashboard(context, true),
                                (error) => _showError(context, error),
                              );
                            },
                            icon: const Icon(Icons.admin_panel_settings,
                                color: Colors.white),
                            label: const Text(
                              "Login as Admin",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade700,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Maintenance Worker Login Button
                          ElevatedButton.icon(
                            onPressed: () {
                              AuthService().googleSignInWithRole(
                                'maintenance',
                                () => _navigateToDashboard(context, false),
                                (error) => _showError(context, error),
                              );
                            },
                            icon: const Icon(Icons.engineering,
                                color: Colors.white),
                            label: const Text(
                              "Login as Maintenance Worker",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade600,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Sign Out Button (for testing)
                          ElevatedButton.icon(
                            onPressed: () => AuthService().signOut(),
                            icon: const Icon(Icons.logout,
                                color: Colors.white),
                            label: const Text(
                              "Sign Out",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 24,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}