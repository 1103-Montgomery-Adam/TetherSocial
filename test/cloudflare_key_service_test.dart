//Jackson Palmer
//11-9-26
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:tether_social/services/CloudflareKeyService.dart';

//to run test:
//flutter test test/cloudflare_key_service_test.dart

void main() {
  group('CloudflareKeyService', () {
    
    test('fetchKey returns the key when the server responds with 200', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.toString(), 'https://key-escrow-service.adammontgomereno.workers.dev/?trackId=track-123');
        return http.Response('123', 200);
      });

      final service = CloudflareKeyService(client: mockClient);
      final result = await service.fetchKey(trackId: 'track-123');
      expect(result, '123');
    });

    test('uploadKey completes successfully when the server responds with 200', () async {
      final mockClient = MockClient((request) async {
        expect(request.method, 'POST');
        expect(request.body, 'my-secret-key');
        return http.Response('OK', 200);
      });

      final service = CloudflareKeyService(client: mockClient);

      await expectLater(
        service.uploadKey(trackId: 'track-123', encryptionKey: 'my-secret-key'),
        completes,
      );
    });

    test('fetchKey throws an exception when the server returns an error', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Not Found', 404);
      });

      final service = CloudflareKeyService(client: mockClient);

      await expectLater(
        service.fetchKey(trackId: 'missing-track'),
        throwsException,
      );
    });
  });
}