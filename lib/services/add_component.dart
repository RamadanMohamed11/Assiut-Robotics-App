import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:robotics_app/models/add_component_model.dart';

class AddComponent {
  Future<void> addComponent(
    String token,
    AddComponentModel addComponentModel,
    File imageFile,
  ) async {
    try {
      // 1️⃣ Upload image to Cloudinary
      String? imageUrl = await uploadImageToCloudinary(imageFile);
      if (imageUrl == null) {
        throw Exception("Failed to upload image");
      }

      // 2️⃣ Prepare the request to your backend
      var uri = Uri.parse(
        'https://assiutroboticswebsite-production.up.railway.app/components/add',
      );

      var request = http.MultipartRequest('POST', uri);

      // Add headers
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Content-Type'] = 'multipart/form-data';

      // Attach component data
      Map<String, dynamic> componentData = addComponentModel.toJson();
      componentData['image'] = imageUrl; // Add the uploaded image URL
      request.fields.addAll(
        componentData.map((key, value) => MapEntry(key, value.toString())),
      );

      // 3️⃣ Send request to backend
      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        print("✅ Component added successfully: $responseData");
      } else {
        print("❌ Failed to add component: ${response.statusCode}");
        print("Response: $responseData");
      }
    } catch (e) {
      print("❌ Error adding component: $e");
    }
  }

  // ✅ Function to upload image to Cloudinary
  Future<String?> uploadImageToCloudinary(File imageFile) async {
    try {
      var uri = Uri.parse(
        "https://api.cloudinary.com/v1_1/dhjyfpw6f/image/upload",
      );

      var request = http.MultipartRequest('POST', uri);
      request.fields['upload_preset'] =
          'ml_default'; // Cloudinary upload preset
      request.files.add(
        await http.MultipartFile.fromPath('file', imageFile.path),
      );

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var jsonResponse = jsonDecode(responseData);

      if (response.statusCode == 200) {
        return jsonResponse['secure_url']; // Return uploaded image URL
      } else {
        print("❌ Cloudinary Upload Failed: $jsonResponse");
        return null;
      }
    } catch (e) {
      print("❌ Error uploading to Cloudinary: $e");
      return null;
    }
  }
}
