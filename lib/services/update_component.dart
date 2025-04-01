import 'dart:convert';
import 'package:http/http.dart' as http;

class UpdateComponent {
  Future<void> updateComponent(
    Map<String, String> formData,
    String token,
  ) async {
    try {
      // ✅ Prepare JSON request body (Use _id instead of id)
      Map<String, dynamic> requestBody = {
        "id": formData["id"], // Ensure correct ID field
        "newpro": {
          "title": formData["title"],
          "price": formData["price"],
          "category": formData["category"],
        },
      };

      // ✅ Send HTTP request
      var response = await http.post(
        Uri.parse("https://assiut-robotics-zeta.vercel.app/components/update"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(requestBody),
      );

      // ✅ Handle response
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        alertUser(jsonResponse['message']);
        getComponents(); // Refresh component list
      } else {
        var jsonResponse = jsonDecode(response.body);
        alertUser(jsonResponse['message']);
      }
    } catch (e) {
      alertUser(e.toString());
    }
  }

  // ✅ Alert function (Replace with UI alert if needed)
  void alertUser(String message) {
    print("🔔 ALERT: $message");
  }

  // ✅ Mock function for refreshing components (Replace with actual function)
  void getComponents() {
    print("🔄 Fetching updated components...");
  }
}
