import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:smart_manufacturing/widgets/custom_appbar.dart';

class WorkerHomePage extends StatelessWidget {
  const WorkerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final User? firebaseUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: CustomAppBar(),
      body: FutureBuilder(
        future:
            FirebaseFirestore.instance
                .collection('users')
                .where('email', isEqualTo: firebaseUser?.email)
                .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Lottie.asset('assets/json/loading.json'));
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error loading tasks"));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No tasks assigned"));
          }

          final workerDoc = snapshot.data!.docs.first;
          final assignedTasks =
              workerDoc.reference.collection('assignedTasks').snapshots();

          return StreamBuilder(
            stream: assignedTasks,
            builder: (context, taskSnapshot) {
              if (taskSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (taskSnapshot.hasError) {
                return Center(child: Text("Error loading tasks"));
              }
              if (!taskSnapshot.hasData || taskSnapshot.data!.docs.isEmpty) {
                return Center(child: Text("No tasks assigned"));
              }

              final tasks = taskSnapshot.data!.docs;

              return ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index].data();
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      title: Text(task['assetName'] ?? 'Unknown Task'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Type: ${task['assetType'] ?? 'N/A'}"),
                          Text("Status: ${task['status'] ?? 'N/A'}"),
                          Text(
                            "Next Maintenance: ${task['nextMaintenance'] ?? 'N/A'}",
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.check, color: Colors.green),
                            onPressed: () async {
                              try {
                                await tasks[index].reference.update({
                                  'status': 'Accepted',
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Task accepted")),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Failed to accept task: $e"),
                                  ),
                                );
                              }
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.close, color: Colors.red),
                            onPressed: () async {
                              try {
                                await tasks[index].reference.update({
                                  'status': 'Rejected',
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Task rejected")),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Failed to reject task: $e"),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
