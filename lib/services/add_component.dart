import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:robotics_app/models/add_component_model.dart';

class AddComponent {
  final String backendUrl =
      "https://assiutroboticswebsite-production.up.railway.app/components/add";
  final String cloudinaryUrl =
      "https://api.cloudinary.com/v1_1/dhjyfpw6f/image/upload";
  final String uploadPreset = "ml_default"; // Cloudinary preset

  Future<void> addComponent(
    String token,
    AddComponentModel addComponentModel,
    File imageFile,
  ) async {
    try {
      print("🚀 Starting Component Upload...");

      // ✅ 1️⃣ Upload image to Cloudinary
      String? imageUrl = await uploadImageToCloudinary(imageFile);
      if (imageUrl == null) {
        throw Exception("Failed to upload image");
      }
      print("✅ Cloudinary Upload Success: $imageUrl");

      // ✅ 2️⃣ Prepare the request
      var uri = Uri.parse(backendUrl);
      var request = http.MultipartRequest('POST', uri);

      // ✅ Headers
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';

      // ✅ Attach component data (like FormData in JS)
      Map<String, dynamic> componentData = addComponentModel.toJson();
      componentData.forEach((key, value) {
        request.fields[key] = value.toString();
        print("$key: $value"); // Debugging
      });

      // ✅ Attach Image File (backend may expect a file instead of URL)
      request.files.add(
        await http.MultipartFile.fromPath(
          'image', // ✅ This is the key expected by the backend
          imageFile.path,
          contentType: MediaType('image', 'jpeg'),
        ),
      );

      // ✅ 3️⃣ Send request
      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var jsonResponse = jsonDecode(responseData);

      if (response.statusCode == 200) {
        print("✅ Component added successfully: $jsonResponse");
        alertUser(jsonResponse['message']);
      } else {
        print("❌ Failed to add component: ${response.statusCode}");
        print("Response: $jsonResponse");
        alertUser(jsonResponse['message']);
      }
    } catch (e) {
      print("❌ Error adding component: $e");
      alertUser(e.toString());
    }
  }

  // ✅ Upload Image to Cloudinary
  Future<String?> uploadImageToCloudinary(File imageFile) async {
    try {
      var uri = Uri.parse(cloudinaryUrl);
      var request = http.MultipartRequest('POST', uri);
      request.fields['upload_preset'] = uploadPreset;

      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          imageFile.path,
          contentType: MediaType('image', 'jpeg'),
        ),
      );

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var jsonResponse = jsonDecode(responseData);

      if (response.statusCode == 200) {
        return jsonResponse['secure_url'];
      } else {
        print("❌ Cloudinary Upload Failed: $jsonResponse");
        return null;
      }
    } catch (e) {
      print("❌ Error uploading to Cloudinary: $e");
      return null;
    }
  }

  // ✅ Alert function
  void alertUser(String message) {
    print("🔔 ALERT: $message");
  }
}
