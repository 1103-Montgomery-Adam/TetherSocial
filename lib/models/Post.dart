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

  factory Post.fromJson(Map<String, dynamic> json) {
  return Post(
    postId: json['postId'] ?? '',
    posterId: json['posterId'] ?? '',
  );
  }

  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'posterId': posterId,
    };
  }
}