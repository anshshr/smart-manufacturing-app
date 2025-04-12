import 'package:flutter/material.dart';
import 'package:smart_manufacturing/pages/admin/pages/admin_profile_page.dart';
import 'package:smart_manufacturing/pages/admin/pages/predictive_analysis_page.dart';
import 'package:smart_manufacturing/pages/admin/pages/worker_management_page.dart';
import 'package:smart_manufacturing/pages/admin/pages/machine_management_page.dart'; // Import Machine Management Page

class AdminBottomNavBar extends StatefulWidget {
  @override
  _AdminBottomNavBarState createState() => _AdminBottomNavBarState();
}

class _AdminBottomNavBarState extends State<AdminBottomNavBar> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    MachineManagementPage(),
    PredictiveAnalysisPage(),
    WorkerManagementPage(),
    AdminProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0), // Add padding to make it floating
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black, // Background color of the navigation bar
            borderRadius: BorderRadius.circular(30), // Curved borders
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3), // Shadow color
                blurRadius: 10, // Blur radius for the shadow
                offset: Offset(0, 5), // Offset for the shadow
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
              30,
            ), // Clip the content to match the border radius
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              backgroundColor:
                  Colors.black, // Set the background color to black
              selectedItemColor:
                  Colors.green.shade600, // Green for selected items
              unselectedItemColor: Colors.black, // White for unselected items
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.normal,
              ),
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(
                  icon: Icon(Icons.bar_chart),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: 'Machines',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
