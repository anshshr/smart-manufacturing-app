import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> sendPushNotification(String message) async {
  final String url = "https://api.onesignal.com/notifications?c=push";

  final Map<String, String> headers = {
    "Authorization":
        "basic os_v2_app_jlcwauy4z5dy5bcgrlcwnyarbemhyaaipsgu3tuzaltaclwmwp2bcbuziumomdnffolbjdpc3wcak2xhnegchxcp6o6xna2wpi56qjy", // 🔥 Replace with your API Key
    "Content-Type": "application/json",
  };

  final Map<String, dynamic> body = {
    "app_id":
        "4ac56053-1ccf-478e-8446-8ac566e01109", 
    "contents": {"en": message}, 
    "headings": {"en": "New Report Available"},
    "included_segments": ["All"], 
    "data": {"reportDetails": "true"},
  };

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      print("✅ Notification Sent Successfully");
    } else {
      print("❌ Failed to send notification: ${response.body}");
    }
  } catch (e) {
    print("🚨 Error sending notification: $e");
  }
}

void main() {
  sendPushNotification("🚀 New event triggered! Check it out.");
}
