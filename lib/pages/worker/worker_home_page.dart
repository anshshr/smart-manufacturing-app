import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WorkerHomePage extends StatelessWidget {
  const WorkerHomePage({super.key});

  Future<List<Map<String, dynamic>>> fetchAssignedTasks() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return [];

    // Get the user's document ID (UID)
    final userId = currentUser.uid;

    try {
      // Query the 'assignedTasks' subcollection for the current user
      final querySnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc("dD9yBAWkldesk17EjEBxuQm1wXg1")
              .collection('assignedTasks')
              .get();

      if (querySnapshot.docs.isEmpty) return [];

      // Convert the query snapshot into a list of maps
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print("Error fetching assigned tasks: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? firebaseUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text("Home page"),
        backgroundColor: Colors.tealAccent,
        centerTitle: true,
      ),

      body: Container(),
    );
  }
}
