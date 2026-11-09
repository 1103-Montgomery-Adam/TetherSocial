//Adam Montgomery
// November 7th, 2026
import 'package:http/http.dart' as http;

class CloudflareKeyService {
  final String _workerBaseUrl = 'https://key-escrow-service.adammontgomereno.workers.dev';

//We'll need to add auth tokens later!!
  Future<String> fetchKey({required String trackId}) async {
    final url = Uri.parse('$_workerBaseUrl/?trackId=$trackId');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return response.body; 
    } else {
      throw Exception('Failed to fetch decryption key.');
    }
  }

  Future<void> uploadKey({required String trackId, required String encryptionKey}) async {
    final url = Uri.parse('$_workerBaseUrl/?trackId=$trackId');

    final response = await http.post(
      url,
      body: encryptionKey, 
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to upload key to Cloudflare.');
    }
  }

  Future<void> deleteKey({required String trackId}) async {
    final url = Uri.parse('$_workerBaseUrl/?trackId=$trackId');

    final response = await http.delete(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to delete key. Status: ${response.statusCode}');
    }
  }
}