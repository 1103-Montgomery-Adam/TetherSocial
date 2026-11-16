//Adam Montgomery
// November 7th, 2026
import 'package:http/http.dart' as http;

class CloudflareKeyService {
  final String _workerBaseUrl = 'https://key-escrow-service.adammontgomereno.workers.dev';

  final http.Client _client;
  CloudflareKeyService({http.Client? client}) : _client = client ?? http.Client();

//We'll need to add auth tokens later!!
  Future<String> fetchKey({required String trackId}) async {
    final url = Uri.parse('$_workerBaseUrl/?trackId=$trackId');

    final response = await _client.get(url);

    if (response.statusCode == 200) {
      return response.body; 
    } else {
      throw Exception('Failed to fetch decryption key.');
    }
  }

  Future<void> uploadKey({required String trackId, required String encryptionKey}) async {
    final url = Uri.parse('$_workerBaseUrl/?trackId=$trackId');

    final response = await _client.post(
      url,
      body: encryptionKey, 
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to upload key to Cloudflare.');
    }
  }

  Future<void> deleteKey({required String trackId}) async {
    final url = Uri.parse('$_workerBaseUrl/?trackId=$trackId');

    final response = await _client.delete(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to delete key. Status: ${response.statusCode}');
    }
  }
}