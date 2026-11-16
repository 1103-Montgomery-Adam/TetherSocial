// import 'dart:convert';
// import 'dart:math';
// import 'dart:typed_data';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:tether_social/services/EncryptionService.dart';

// void main() {
//   group('EncryptionService ChaCha20 Tests', () {
//     late EncryptionService encryptionService;

//     setUp(() {
//       encryptionService = EncryptionService();
//     });

//     test('encrypt and decrypt round trip returns identical audio data', () {
//       // Create simulated audio bytes
//       final originalAudio = Uint8List.fromList(
//         List.generate(256, (i) => (i * 7 + 13) % 256),
//       );

//       final result = encryptionService.encrypt(originalAudio);

//       // Verify that key is 32 bytes and encrypted audio has nonce prepended
//       expect(result.key.length, 32);
//       expect(result.nonce.length, 12);
//       expect(result.encryptedAudio.length, 12 + originalAudio.length);

//       // Verify ciphertext differs from original audio
//       final ciphertextOnly = result.encryptedAudio.sublist(12);
//       expect(ciphertextOnly, isNot(equals(originalAudio)));

//       // Decrypt using the returned key
//       final decryptedAudio = encryptionService.decrypt(
//         result.encryptedAudio,
//         result.key,
//       );

//       expect(decryptedAudio, equals(originalAudio));
//     });

//     test('supports Dart 3 record destructuring', () {
//       final sampleAudio = Uint8List.fromList(utf8.encode('Sample audio track data'));

//       final (encryptedAudio, key) = encryptionService.encrypt(sampleAudio).record;

//       final decrypted = encryptionService.decrypt(encryptedAudio, key);
//       expect(decrypted, equals(sampleAudio));
//     });

//     test('encrypt with a user-provided 32-byte key works correctly', () {
//       final customKey = Uint8List.fromList(List.generate(32, (i) => i));
//       final audioData = Uint8List.fromList(utf8.encode('Tether audio test payload'));

//       final result = encryptionService.encrypt(audioData, key: customKey);

//       expect(result.key, equals(customKey));

//       final decrypted = encryptionService.decrypt(result.encryptedAudio, customKey);
//       expect(decrypted, equals(audioData));
//     });

//     test('decrypting with the wrong key does not yield original plaintext', () {
//       final audioData = Uint8List.fromList(utf8.encode('Secret audio data'));
//       final result = encryptionService.encrypt(audioData);

//       final wrongKey = Uint8List.fromList(List.generate(32, (i) => 255 - i));
//       final corrupted = encryptionService.decrypt(result.encryptedAudio, wrongKey);

//       expect(corrupted, isNot(equals(audioData)));
//     });

//     test('handles large audio data (1 MB simulation)', () {
//       final random = Random(42);
//       final oneMbAudio = Uint8List(1024 * 1024);
//       for (var i = 0; i < oneMbAudio.length; i++) {
//         oneMbAudio[i] = random.nextInt(256);
//       }

//       final result = encryptionService.encrypt(oneMbAudio);
//       expect(result.encryptedAudio.length, 12 + oneMbAudio.length);

//       final decrypted = encryptionService.decrypt(result.encryptedAudio, result.key);
//       expect(decrypted, equals(oneMbAudio));
//     });

//     test('empty audio payload encrypts and decrypts cleanly', () {
//       final emptyAudio = Uint8List(0);
//       final result = encryptionService.encrypt(emptyAudio);

//       expect(result.encryptedAudio.length, 12); // Only nonce

//       final decrypted = encryptionService.decrypt(result.encryptedAudio, result.key);
//       expect(decrypted.length, 0);
//     });

//     test('throws ArgumentError if key is not 32 bytes', () {
//       final audio = Uint8List(10);
//       final shortKey = Uint8List(16);

//       expect(
//         () => encryptionService.encrypt(audio, key: shortKey),
//         throwsArgumentError,
//       );

//       expect(
//         () => encryptionService.decrypt(Uint8List(20), shortKey),
//         throwsArgumentError,
//       );
//     });

//     test('throws ArgumentError if encrypted payload is shorter than 12 bytes', () {
//       final tooShortPayload = Uint8List(8);
//       final validKey = Uint8List(32);

//       expect(
//         () => encryptionService.decrypt(tooShortPayload, validKey),
//         throwsArgumentError,
//       );
//     });

//     test('Base64 and Hex key helpers encode and decode correctly', () {
//       final key = encryptionService.generateKey();

//       final base64String = EncryptionService.keyToBase64(key);
//       final restoredFromBase64 = EncryptionService.keyFromBase64(base64String);
//       expect(restoredFromBase64, equals(key));

//       final hexString = EncryptionService.keyToHex(key);
//       final restoredFromHex = EncryptionService.keyFromHex(hexString);
//       expect(restoredFromHex, equals(key));
//     });
//   });
// }

