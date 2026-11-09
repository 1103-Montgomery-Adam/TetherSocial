//Adam Montgomery
//November 9th, 2026

import 'package:flutter_test/flutter_test.dart';
import 'dart:typed_data';
import 'package:tether_social/models/post.dart';

//Use "flutter test test/post_test.dart" to run these tests

void main() {
  group("Post Model Tests -", () {
    test("toJson creates a dictionary without audioBytes", () {
      final testPost = Post(
        postId: "test-123",
        posterId: "AdamM",
        audioBytes: Uint8List.fromList([1, 2, 3]),
      );

      final resultJson = testPost.toJson();

      expect(resultJson["postId"], "test-123");
      expect(resultJson["posterId"], "AdamM");
      expect(resultJson.containsKey("audioBytes"), false);
    });

    test("fromJson creates a Post object without audioBytes", () {
      final testPost = Post(
        postId: "test-123",
        posterId: "AdamM",
        audioBytes: Uint8List.fromList([1, 2, 3]),
      );

      final testJson = testPost.toJson();
      final translatedPost = Post.fromJson(testJson);

      expect(translatedPost.postId, "test-123");
      expect(translatedPost.posterId, "AdamM");
      expect(translatedPost.audioBytes == null, true);
    });
  });
}
