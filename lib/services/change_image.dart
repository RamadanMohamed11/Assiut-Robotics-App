import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart'; // ✅ Needed for MIME types
import 'package:image/image.dart' as img; // ✅ Needed for image conversion

class ProfileService {
  final String apiUrl =
      'https://assiut-robotics-zeta.vercel.app/members/changeProfileImage';

  Future<void> changeProfileImage(File imageFile, String token) async {
    if (token.isEmpty) {
      print('❌ No token provided!');
      return;
    }

    String filePath = imageFile.path;
    String fileExtension = filePath.split('.').last.toLowerCase();

    print('📸 Uploading file: $filePath');
    print('📝 File Extension: $fileExtension');

    // ✅ Ensure it's a valid image format
    if (!['jpg', 'jpeg', 'png'].contains(fileExtension)) {
      print('❌ Invalid file type: $fileExtension');
      return;
    }

    // ✅ Convert image if necessary
    if (fileExtension != 'jpg') {
      imageFile = await convertToJpg(imageFile);
      print('🔄 Converted image to JPG: ${imageFile.path}');
    }

    var uri = Uri.parse(apiUrl);
    var request = http.MultipartRequest('POST', uri);

    // ✅ Add headers (Authorization)
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Accept'] = 'application/json';

    // ✅ Attach image file with correct MIME type
    request.files.add(
      await http.MultipartFile.fromPath(
        'image', // ✅ Ensure this matches the backend expectation
        imageFile.path,
        contentType: MediaType('image', 'jpeg'),
      ),
    );

    try {
      var response = await request.send();
      var responseData = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        var data = jsonDecode(responseData.body);
        print('✅ Profile image updated: ${data['avatar']}');
      } else {
        print('❌ Failed: ${response.statusCode}');
        print('Response: ${responseData.body}');
      }
    } catch (error) {
      print('❌ Error changing avatar: $error');
    }
  }

  // ✅ Convert Image to JPG
  Future<File> convertToJpg(File imageFile) async {
    img.Image? image = img.decodeImage(await imageFile.readAsBytes());
    if (image == null) {
      print('❌ Failed to decode image');
      return imageFile;
    }

    File newImage = File('${imageFile.path}.jpg')
      ..writeAsBytesSync(img.encodeJpg(image));

    return newImage;
  }
}

// ✅ Function to Pick Image & Upload
Future<void> uploadProfileImage(String token) async {
  final ImagePicker picker = ImagePicker();
  final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile == null) {
    print('❌ No image selected');
    return;
  }

  File imageFile = File(pickedFile.path);
  ProfileService().changeProfileImage(imageFile, token);
}
