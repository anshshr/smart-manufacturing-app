import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:smart_manufacturing/widgets/custom_appbar.dart';

class PredictiveAnalysisPage extends StatefulWidget {
  const PredictiveAnalysisPage({super.key});

  @override
  State<PredictiveAnalysisPage> createState() => _PredictiveAnalysisPageState();
}

class _PredictiveAnalysisPageState extends State<PredictiveAnalysisPage> {
  List<dynamic> machineDetails = [];

  @override
  void initState() {
    super.initState();
    fetchMachineDetails();
  }

  Future<void> fetchMachineDetails() async {
    final url = Uri.parse('http://192.168.55.229:3000/api/data/machinDetails');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          machineDetails = json.decode(response.body);
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body:
          machineDetails.isEmpty
              ? Center(
                child: Lottie.asset('assets/json/circular_progress.json'),
              )
              : ListView.builder(
                itemCount: machineDetails.length,
                itemBuilder: (context, index) {
                  final machine = machineDetails[index];
                  return Card(
                    margin: const EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Machine Name and Status
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                machine['name'] ?? 'Unknown',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Chip(
                                label: Text(
                                  machine['status'] ?? 'N/A',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                backgroundColor:
                                    machine['status'] == 'Operational'
                                        ? Colors.green
                                        : Colors.red,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // Machine Details
                          Row(
                            children: [
                              const Icon(Icons.numbers, color: Colors.blue),
                              const SizedBox(width: 8),
                              Text(
                                'Machine ID: ${machine['machineId'] ?? 'N/A'}',
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const Icon(Icons.location_on, color: Colors.blue),
                              const SizedBox(width: 8),
                              Text('Location: ${machine['location'] ?? 'N/A'}'),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_today,
                                color: Colors.blue,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Install Date: ${machine['installDate']?.split('T')[0] ?? 'N/A'}',
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const Icon(Icons.build, color: Colors.blue),
                              const SizedBox(width: 8),
                              Text(
                                'Last Maintenance: ${machine['lastMaintenance']?.split('T')[0] ?? 'N/A'}',
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const Icon(Icons.schedule, color: Colors.blue),
                              const SizedBox(width: 8),
                              Text(
                                'Next Maintenance: ${machine['nextMaintenance']?.split('T')[0] ?? 'N/A'}',
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const Icon(Icons.factory, color: Colors.blue),
                              const SizedBox(width: 8),
                              Text(
                                'Manufacturer: ${machine['manufacturer'] ?? 'N/A'}',
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const Icon(
                                Icons.model_training,
                                color: Colors.blue,
                              ),
                              const SizedBox(width: 8),
                              Text('Model: ${machine['model'] ?? 'N/A'}'),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // Machine Images
                          if (machine['image'] != null &&
                              (machine['image'] as List).isNotEmpty)
                            SizedBox(
                              height: 120,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: (machine['image'] as List).length,
                                itemBuilder: (context, imgIndex) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        machine['image'][imgIndex],
                                        width: 120,
                                        height: 120,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
