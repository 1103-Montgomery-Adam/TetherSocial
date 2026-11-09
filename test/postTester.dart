// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:typed_data';
import 'package:tether_social/models/post.dart';

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

    test()
  });
}
