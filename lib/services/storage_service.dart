
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> uploadProfileImage(String userId, XFile imageFile) async {
    try {
      final ref = _storage.ref().child('user_profiles').child('$userId.jpg');
      final uploadTask = await ref.putFile(File(imageFile.path));
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading profile image: $e');
      return null;
    }
  }

  Future<String> getStorageUri(String fullPath) async {
    final ref = _storage.refFromURL(fullPath);
    return 'gs://${ref.bucket}/${ref.fullPath}';
  }
}
