import 'dart:typed_data';

class Post {
  final String postId;    
  final String posterId;
  final Uint8List? audioBytes; 

  Post({
    required this.postId,
    required this.posterId,
    this.audioBytes,
  });
}