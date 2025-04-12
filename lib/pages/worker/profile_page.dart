import 'package:flutter/material.dart';

class WorkerProfilePage extends StatelessWidget {
  const WorkerProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Worker Profile'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 6,
            margin: const EdgeInsets.all(20),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                      "https://www.shutterstock.com/image-photo/portrait-african-black-worker-standing-600nw-2114436797.jpg",
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Ravi Kumar',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Maintenance Technician',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const Divider(height: 30, thickness: 1.2),

                  _infoTile('Shift Timing', '08:00 AM - 04:00 PM'),
                  _infoTile(
                    'Machines Assigned',
                    'Conveyor Belt 1, Press Machine 2',
                  ),
                  _infoTile('Last Maintenance', 'April 9, 2025'),
                  _infoTile('Alerts Handled', '5 in last 7 days'),
                  _infoTile('Status', 'Active'),

                  const SizedBox(height: 20),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Performance',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 5),
                  LinearProgressIndicator(
                    value: 0.85,
                    minHeight: 8,
                    backgroundColor: Colors.grey[300],
                    color: Colors.teal,
                  ),
                  const SizedBox(height: 5),
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '85%',
                      style: TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoTile(String title, String subtitle) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.info_outline, color: Colors.teal),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle),
    );
  }
}
