import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smart_manufacturing/services/pdf_services.dart';
import 'package:smart_manufacturing/services/percentage_pie_chart.dart';

class PredictiveAnalysisPage extends StatefulWidget {
  const PredictiveAnalysisPage({super.key});

  @override
  State<PredictiveAnalysisPage> createState() => _PredictiveAnalysisPageState();
}

class _PredictiveAnalysisPageState extends State<PredictiveAnalysisPage> {
  List<Map<String, dynamic>> predictions = [];

  @override
  void initState() {
    super.initState();
    fetchAndPredictData();
  }

  Future<void> fetchAndPredictData() async {
    try {
      // Fetch data from the first API
      final response = await http.get(
        Uri.parse('http://192.168.200.56:3000/api/data/recent'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        // Iterate over each object and make a POST request to the second API
        for (var item in data) {
          final predictionResponse = await http.post(
            Uri.parse(
              'https://predective-maintenance-models.onrender.com/predict',
            ),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              "Type": "0",
              "Air temperature [K]": item['airTemperature'],
              "Process temperature [K]": item['processTemperature'],
              "Rotational speed [rpm]": item['rotationalSpeed'],
              "Torque [Nm]": item['torque'],
              "Tool wear [min]": item['toolWear'],
            }),
          );

          if (predictionResponse.statusCode == 200) {
            final predictionData = json.decode(predictionResponse.body);
            setState(() {
              predictions.add({
                "timestamp":
                    item['timestamp'] is Map
                        ? item['timestamp']['\$date']
                        : item['timestamp'],
                "probability": predictionData['probability'],
                "message": predictionData['message'],
                "airTemperature": item['airTemperature'],
                "processTemperature": item['processTemperature'],
                "rotationalSpeed": item['rotationalSpeed'],
                "torque": item['torque'],
                "toolWear": item['toolWear'],
              });
            });
          }
        }
      }
      print(predictions);
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Predictive Analysis')),
      body:
          predictions.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: predictions.length,
                itemBuilder: (context, index) {
                  final prediction = predictions[index];
                  print(prediction);
                  return InkWell(
                    onTap: ()  async{
                    await  generateToolReport(prediction);
                    },
                    child: Card(
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text('Timestamp: ${prediction["timestamp"]}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Probability: ${prediction["probability"].toStringAsFixed(2)}',
                            ),
                            Text('Message: ${prediction["message"]}'),
                            Text('Type: 0'),
                            Text(
                              'Air temperature [K]: ${prediction["airTemperature"]}',
                            ),
                            Text(
                              'Process temperature [K]: ${prediction["processTemperature"]}',
                            ),
                            Text(
                              'Rotational speed [rpm]: ${prediction["rotationalSpeed"]}',
                            ),
                            Text('Torque [Nm]: ${prediction["torque"]}'),
                            Text('Tool wear [min]: ${prediction["toolWear"]}'),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10.0,
                              ),
                              child: SizedBox(
                                height: 200,
                                child: PercentagePieChart(
                                  percentage: prediction["probability"] * 100,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
