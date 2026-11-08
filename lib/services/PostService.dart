import'services/CloudflareKeyService.dart';
import 'models/Post.dart'


class PostService{    
 final CloudflareKeyService cloudflareService = CloudflareKeyService();
 //final CloudStorageManager cloudStorageService = CloudStorageManager()

 Future<void> uploadPost(required Post post) async {
    //We may want to make these upload operations atomically coupled in the future
    //try await cloudStorageService.uploadAudio(trackId: post.postId, audio: post.audioBytes)
    try await cloudflareService.uploadKey(trackId: post.postId, encryptionKey: "123");
 }
}