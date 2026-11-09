import'CloudflareKeyService.dart';
import '../models/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class PostService{ 
 final FirebaseFirestore _db = FirebaseFirestore.instance;

 Future<void> uploadPost({required Post post}) async {
   final docRef = _db.collection('posts').doc(post.postId);
   try {
      await docRef.set(post.toJson());
      print("Success!");
   } catch(e) {
      throw Exception("Firestore Upload Error: $e");
   }
 }

 Future<Post?> downloadPost({required String postId}) async {
   try {
    final docSnapshot = await _db.collection('posts').doc(postId).get();
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

 Future<void> deletePost(String postId) async {
  try {
    await _db.collection('posts').doc(postId).delete();
    print("Success: Firestore document $postId deleted");
  } catch (e) {
    throw Exception("Firestore Delete Error: $e");
  }
}
}