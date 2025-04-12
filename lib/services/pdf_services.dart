import 'dart:io';

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

Future<void> generateToolReport(Map<String, dynamic> transactionData) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Title
            pw.Text(
              "Tool Condition Report",
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 20),

            // Report Summary
            pw.Text(
              "Report Summary:",
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(transactionData["message"] ?? "No summary available"),
            pw.SizedBox(height: 10),

            // Prediction and Probability
            pw.Text(
              "Prediction and Probability:",
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              "Prediction: ${transactionData["probability"].toStringAsFixed(2) ?? "N/A"}",
            ),
            pw.Text(
              "Probability: ${(transactionData["probability"] ?? 0) * 100}%",
            ),
            pw.SizedBox(height: 10),

            // Tool Parameters
            pw.Text(
              "Tool Parameters:",
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 5),
            pw.Text(
              "Air Temperature: ${transactionData["airTemperature"] ?? "N/A"} K",
            ),
            pw.Text(
              "Process Temperature: ${transactionData["processTemperature"] ?? "N/A"} K",
            ),
            pw.Text(
              "Rotational Speed: ${transactionData["rotationalSpeed"] ?? "N/A"} RPM",
            ),
            pw.Text("Torque: ${transactionData["torque"] ?? "N/A"} Nm"),
            pw.Text("Tool Wear: ${transactionData["toolWear"] ?? "N/A"} min"),
            pw.SizedBox(height: 10),

            // Timestamp
            pw.Text(
              "Timestamp:",
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(transactionData["timestamp"] ?? "N/A"),
          ],
        );
      },
    ),
  );

  // Save PDF
  final outputDir = await getTemporaryDirectory();
  final file = File("${outputDir.path}/tool_condition_report.pdf");
  await file.writeAsBytes(await pdf.save());

  // Open PDF
  await OpenFile.open(file.path);
}
