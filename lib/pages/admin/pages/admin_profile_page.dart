import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:smart_manufacturing/widgets/custom_appbar.dart';

class AdminProfilePage extends StatefulWidget {
  const AdminProfilePage({super.key});

  @override
  State<AdminProfilePage> createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage> {
  Future<Map<String, dynamic>?> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();
      return snapshot.data();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _fetchUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Lottie.asset('assets/json/loading.json'));
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading profile"));
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("No profile data found"));
          }

          final userData = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Image
                CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      userData['photoUrl'] != null
                          ? NetworkImage(userData['photoUrl'])
                          : null,
                  child:
                      userData['photoUrl'] == null
                          ? const Icon(Icons.person, size: 50)
                          : null,
                ),
                const SizedBox(height: 16),

                // Name
                Text(
                  userData['name'] ?? 'No Name',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // Email
                Text(
                  userData['email'] ?? 'No Email',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 8),

                // Role
                Chip(
                  label: Text(
                    userData['role'] ?? 'No Role',
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.blue,
                ),

                const SizedBox(height: 24),

                // Additional Information
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text('Additional Info'),
                  subtitle: Text(
                    userData['additionalInfo'] ?? 'No additional information',
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
