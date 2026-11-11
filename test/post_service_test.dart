//Jackson Palmer
//11-10-26
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tether_social/models/Post.dart';
import 'package:tether_social/services/PostService.dart';

//to run test:
//flutter test test/post_service_test.dart

void main() {
  group('PostService', () {
    late FakeFirebaseFirestore fakeDb;
    late PostService postService;

    setUp(() {
      fakeDb = FakeFirebaseFirestore();
      postService = PostService(db: fakeDb);
    });

    test('uploadPost saves a post to Firestore', () async {
      final post = Post(postId: 'post-123', posterId: 'artist-456');

      await postService.uploadPost(post: post);

      final snapshot = await fakeDb.collection('posts').doc('post-123').get();
      expect(snapshot.exists, isTrue);
      expect(snapshot.data()?['posterId'], 'artist-456');
    });

    test('downloadPost retrieves the correct post', () async {
      final post = Post(postId: 'post-123', posterId: 'artist-456');
      await postService.uploadPost(post: post);

      final downloadedPost = await postService.downloadPost(postId: 'post-123');

      expect(downloadedPost, isNotNull);
      expect(downloadedPost!.postId, 'post-123');
      expect(downloadedPost.posterId, 'artist-456');
    });

    test('downloadPost returns null when the post does not exist', () async {
      final downloadedPost = await postService.downloadPost(postId: 'missing-post');

      expect(downloadedPost, isNull);
    });

    test('deletePost removes the post from Firestore', () async {
      final post = Post(postId: 'post-123', posterId: 'artist-456');
      await postService.uploadPost(post: post);

      await postService.deletePost('post-123');

      final snapshot = await fakeDb.collection('posts').doc('post-123').get();
      expect(snapshot.exists, isFalse);
    });
  });
}