import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StorageRepository {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload an image to Firebase Storage and return the download URL
  Future<String> uploadProfileImage(XFile imageFile, String userId) async {
    try {
      // Create a unique file name using timestamp
      final String fileName = '${DateTime.now().millisecondsSinceEpoch}_${imageFile.name}';
      
      // Reference to storage location: user_uploads/{uid}/profile_photos/{fileName}
      final Reference ref = _storage
          .ref()
          .child('user_uploads/$userId/profile_photos/$fileName');

      // Upload file with metadata
      final UploadTask uploadTask = ref.putFile(
        File(imageFile.path),
        SettableMetadata(contentType: 'image/jpeg'), // Adjust based on file type if needed
      );

      // Wait for upload to complete
      final TaskSnapshot snapshot = await uploadTask;

      // Get download URL
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }
}
