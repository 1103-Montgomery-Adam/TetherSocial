//Jackson Palmer
//November 8th

import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

class CloudStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Uploads audio data to firebase storage
  Future<String> uploadAudio({
    required String trackId, 
    required Uint8List audio,
  }) async {
    try {
      final Reference storageRef = _storage.ref().child('audio/$trackId.mp3');
      // edits metadata for firebase to see the upload as an audio file
      final SettableMetadata metadata = SettableMetadata(contentType: 'audio/mpeg');
      final UploadTask uploadTask = storageRef.putData(audio, metadata);
      // waits for for complete upload
      final TaskSnapshot snapshot = await uploadTask;
      // gets and returns the download URL
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
      
    } catch (e) {
      print("CloudStorageService Upload Error: $e");
      rethrow; // assumes PostService will handle error
    }
  }

  // downloads audio data from firebase cloud storage
  Future<Uint8List?> downloadAudio({required String trackId}) async {
    try {
      final Reference storageRef = _storage.ref().child('audio/$trackId.mp3');
      final Uint8List? audioBytes = await storageRef.getData();
      return audioBytes;
    
    } catch (e) {
      print("CloudStorageService Download Error: $e");
      return null; // if download fails
    }
  }

  Future<void> deleteAudio({required String trackId}) async {
    try {
      final Reference storageRef = _storage.ref().child('audio/$trackId.mp3');
      await storageRef.delete();
      print("Success deleting Cloud storage reference");
    } catch (e) {
      print("CloudStorageService Delete Error: $e");
      throw Exception("Failed to delete audio: $e");
    }
  }
}