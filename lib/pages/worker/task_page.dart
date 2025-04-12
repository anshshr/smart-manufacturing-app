import 'package:flutter/material.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Work Order'),
        backgroundColor: Colors.teal,
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              "Start work",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHeaderSection(),
          const SizedBox(height: 16),
          _buildDetailsSection(),
          const SizedBox(height: 16),
          _buildAssetSection(context),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Centrifugal Pump Oil Change',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Chip(label: Text("Approved")),
            const Chip(label: Text("Priority 1")),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailsSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Details',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            const Text(
              'The centrifugal pump oil change must be performed every 3 months to meet manufacturer warranty conditions. '
              'Perform the oil change according to the manufacturer’s recommended guidelines, which are documented in the steps.',
            ),
            const SizedBox(height: 12),
            Row(
              children: const [
                Icon(Icons.calendar_today, size: 18),
                SizedBox(width: 8),
                Text('3/16/2023, 8:30 AM - 12:00 PM'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: const [
                Icon(Icons.location_on, size: 18),
                SizedBox(width: 8),
                Text('123 Main Street, Chicago, IL'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: const [
                Icon(Icons.confirmation_num_outlined, size: 18),
                SizedBox(width: 8),
                Text('GL Account: 6210-300-000'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: const [
                Icon(Icons.verified_user_outlined, size: 18),
                SizedBox(width: 8),
                Text('Warranty: Yes'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: const [
                Icon(Icons.category_outlined, size: 18),
                SizedBox(width: 8),
                Text('Classification: PUMP/CNTRFGL'),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Icon(Icons.assignment, color: Colors.teal),
                Icon(Icons.settings, color: Colors.teal),
                Icon(Icons.photo_camera, color: Colors.teal),
                Icon(Icons.chat_bubble_outline, color: Colors.teal),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssetSection(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Asset and Location',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text('CS11430 – Centrifugal Pump 100GPM/60FTHD'),
            const Text('Main Boiler Room'),
            const Text('Ingersoll-Rand Company'),
            const Text('Purchase Price: \$19,200'),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQvmN9FnPrA8-pOeliMN4sZUFCy1jTRtcPAlA&s', // Replace with real asset path
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
