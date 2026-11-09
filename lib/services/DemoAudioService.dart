//Elijah Gutierrez 11/8/2026

import 'dart:typed_data';
import 'package:tether_social/services/CloudflareKeyService.dart';
import 'package:tether_social/services/CloudStorageService.dart';
import 'package:tether_social/services/PostService.dart';
import '../models/post.dart';
// Demo-only service for the audio demo screen.
class DemoAudioService {
  final CloudflareKeyService _cloudflare = CloudflareKeyService();
  final CloudStorageService _cloudStorage = CloudStorageService(); 
  final PostService postService = PostService();
  // fake bucket for stubbing functions
  static final Map<String, Uint8List> _fakeBucket = {};
  // Placeholder key until real encryption is added.
  static const String _demoKey = '123';

  Future<void> upload({required String trackId, required Uint8List audio}) async {
    await _cloudStorage.uploadAudio(trackId: trackId, audio: audio);
    await _cloudflare.uploadKey(trackId: trackId, encryptionKey: _demoKey);
    final demoPost = Post(postId: trackId, posterId: "Bobby", audioBytes: audio);
    await postService.uploadPost(post: demoPost);    
  }

  Future<Uint8List?> download({required String trackId}) async {
    final audio = await _cloudStorage.downloadAudio(trackId: trackId);
    if (audio == null) return null;
    await _cloudflare.fetchKey(trackId: trackId); // not used yet, shows the Cloudflare st            ep
    final post = await postService.downloadPost(postId: trackId); // not used yet 
    return audio;
  }

  Future<void> delete({required String trackId}) async {
    _fakeBucket.remove(trackId); // STUB: replace with Cloud Storage delete
    await _cloudflare.deleteKey(trackId: trackId);
    await postService.deletePost(trackId);
  }
}
