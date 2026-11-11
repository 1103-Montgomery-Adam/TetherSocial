//Jackson Palmer
//10-10-26
import 'dart:convert';
import 'dart:typed_data';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tether_social/services/CloudStorageService.dart';

//to run test:
//flutter test test/cloud_storage_service_test.dart

void main() {
  late CloudStorageService storageService;
  late MockFirebaseStorage mockStorage;

  setUp(() {
    //sets up the mocking using firebase mock package
    mockStorage = MockFirebaseStorage();
    storageService = CloudStorageService(storage: mockStorage);
  });

  test('uploadAudio successfully uploads bytes and returns a download URL', () async {
    final testTrackId = 'test-track-123';
    final testBytes = Uint8List.fromList(utf8.encode('This is fake audio data'));

    final downloadUrl = await storageService.uploadAudio(
      trackId: testTrackId, 
      audio: testBytes,
    );

    expect(downloadUrl, isNotEmpty);
    expect(downloadUrl, contains(testTrackId));
  });

  test('downloadAudio successfully retrieves the uploaded bytes', () async {
    final testTrackId = 'test-track-456';
    final testBytes = Uint8List.fromList(utf8.encode('More fake audio data'));
    
    await storageService.uploadAudio(trackId: testTrackId, audio: testBytes);

    final downloadedBytes = await storageService.downloadAudio(trackId: testTrackId);

    expect(downloadedBytes, isNotNull);
    expect(downloadedBytes, equals(testBytes));
  });
}