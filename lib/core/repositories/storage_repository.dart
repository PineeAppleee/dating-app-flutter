import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class StorageRepository {

  Future<String> uploadProfileImage(XFile imageFile, String userId) async {
    try {

      print("🔥 CLOUDINARY FUNCTION RUNNING");

      const cloudName = "diqu7suef";
      const uploadPreset = "mioryygp";

      final url = Uri.parse(
          "https://api.cloudinary.com/v1_1/$cloudName/image/upload");

      var request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = uploadPreset
        ..files.add(await http.MultipartFile.fromPath(
          'file',
          imageFile.path,
        ));

      var response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final jsonData = json.decode(responseData);

        String imageUrl = jsonData['secure_url'];
        print("✅ UPLOAD SUCCESS: $imageUrl");

        return imageUrl;
      } else {
        throw Exception("Cloudinary upload failed");
      }

    } catch (e) {
      print("❌ UPLOAD ERROR: $e");
      throw Exception("Failed to upload image: $e");
    }
  }
}