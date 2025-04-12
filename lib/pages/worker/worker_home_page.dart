import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_manufacturing/services/notification_service.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        backgroundColor: Colors.tealAccent,
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchAssignedTasks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: ElevatedButton(
                onPressed: () async {
                  await sendPushNotification("hello");
                },
                child: Text("Send Notification"),
              ),
            );
          }

          final tasks = snapshot.data!;

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(task['assetName'] ?? 'No Name'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Type: ${task['assetType']}"),
                      Text("Status: ${task['status']}"),
                      Text("Next Maintenance: ${task['nextMaintenance']}"),
                      if (task['coordinates'] != null)
                        Text(
                          "Location: (${task['coordinates']['latitude']}, ${task['coordinates']['longitude']})",
                        ),
                    ],
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {
                      // Add action for more details or navigation
                      print("View details for task: ${task['assetName']}");
                    },
                    child: const Text("Details"),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
