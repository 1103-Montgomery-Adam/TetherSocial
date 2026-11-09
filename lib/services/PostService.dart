import'CloudflareKeyService.dart';
import '../models/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class PostService{ 
 final CloudflareKeyService cloudflareService = CloudflareKeyService();
 //final CloudStorageManager cloudStorageService = CloudStorageManager()
 final FirebaseFirestore _db = FirebaseFirestore.instance;

 Future<void> uploadPost({required Post post}) async {
   final docRef = _db.collection('posts').doc(post.postId);

    //We may want to make these upload operations atomically coupled in the future
   try {
      await cloudflareService.uploadKey(trackId: post.postId, encryptionKey: "123");
      await docRef.set(post.toJson());
      //await cloudStorageService.uploadAudio(trackId: post.postId, audio: post.audioBytes)
      print("Success!");
   } catch(e) {
      throw Exception("Firestore Upload Error: $e");
   }
 }

 Future<Post?> downloadPost({required String postId}) async {
   try {
    final docSnapshot = await _db.collection('posts').doc(postId).get();
    final key = await cloudflareService.fetchKey(trackId: postId);
    if (docSnapshot.exists && docSnapshot.data() != null) {
      print("Success: Retrieved post metadata for $postId");
      return Post.fromJson(docSnapshot.data()!);
    } else {
      print("No post found with ID $postId");
      return null;
    }
  } catch (e) {
    throw Exception("Firestore Fetch error: $e");
  }
 }
}