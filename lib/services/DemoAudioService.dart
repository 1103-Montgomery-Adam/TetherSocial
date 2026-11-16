//Elijah Gutierrez 11/8/2026

import 'dart:typed_data';
import 'package:tether_social/services/CloudflareKeyService.dart';
import 'package:tether_social/services/CloudStorageService.dart';
import 'package:tether_social/services/PostService.dart';
import 'package:tether_social/services/EncryptionService.dart';
import '../models/post.dart';
import '../models/Post.dart';
// Demo-only service for the audio demo screen.
class DemoAudioService {
  final CloudflareKeyService _cloudflare = CloudflareKeyService();
  final CloudStorageService _cloudStorage = CloudStorageService(); 
  final EncryptionService _encryptionService = EncryptionService();
  final PostService postService = PostService();
  // fake bucket for stubbing functions
  //static final Map<String, Uint8List> _fakeBucket = {};
  // Placeholder key until real encryption is added.
  static const String _demoKey = '123';

  Future<void> upload({required String trackId, required Uint8List audio}) async {
    final EncryptionResult encryptionData = _encryptionService.encrypt(audio);
    await _cloudStorage.uploadAudio(trackId: trackId, audio: encryptionData.encryptedAudio);
    await _cloudflare.uploadKey(trackId: trackId, encryptionKey: EncryptionService.keyToHex(encryptionData.key));
    final demoPost = Post(postId: trackId, posterId: "Bobby", audioBytes: null);
    await postService.uploadPost(post: demoPost);    
  }

  Future<Uint8List?> download({required String trackId}) async {
    final Uint8List? encryptedAudio = await _cloudStorage.downloadAudio(trackId: trackId);
    final String rawKey = await _cloudflare.fetchKey(trackId: trackId);
    final Uint8List key = EncryptionService.keyFromHex(rawKey);
    if (encryptedAudio != null){
      final audio = _encryptionService.decrypt(encryptedAudio, key);
      return audio;
    }
    return null;
    // if (audio == null) return null;
    // await _cloudflare.fetchKey(trackId: trackId); // not used yet, shows the Cloudflare st
    // final post = await postService.downloadPost(postId: trackId); // not used yet 
    // return audio;
  }

  Future<void> delete({required String trackId}) async {
    await _cloudStorage.deleteAudio(trackId: trackId);
    await _cloudflare.deleteKey(trackId: trackId);
    await postService.deletePost(trackId);
  }
}
