import 'package:flutter/material.dart';
import 'package:smart_manufacturing/pages/worker/profile_page.dart';
import 'package:smart_manufacturing/pages/worker/task_page.dart';
import 'package:smart_manufacturing/pages/worker/worker_home_page.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    WorkerHomePage(),
    TaskPage(),
    ProfilePage(),
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
