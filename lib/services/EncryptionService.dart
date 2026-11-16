//Adam Montgomery
//November 16th, 2026

import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

class EncryptionResult {
  final Uint8List encryptedAudio;

  final Uint8List key;

  final Uint8List nonce;

  const EncryptionResult({
    required this.encryptedAudio,
    required this.key,
    required this.nonce,
  });

  String get keyBase64 => base64Encode(key);


  String get keyHex =>
      key.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();

  (Uint8List encryptedAudio, Uint8List key) toRecord() =>
      (encryptedAudio, key);

  
  //(Uint8List, Uint8List) get record => (encryptedAudio, key);
}

class EncryptionService {
  static const int keySize = 32;

  static const int nonceSize = 12;

  static const int blockSize = 64;

  static const int _c0 = 0x61707865;
  static const int _c1 = 0x3320646e;
  static const int _c2 = 0x79622d32;
  static const int _c3 = 0x6b206574;

  final Random _secureRandom = Random.secure();

  Uint8List generateKey() {
    final key = Uint8List(keySize);
    for (var i = 0; i < keySize; i++) {
      key[i] = _secureRandom.nextInt(256);
    }
    return key;
  }

  EncryptionResult encrypt(
    Uint8List audio, {
    Uint8List? key,
    Uint8List? nonce,
  }) {
    final effectiveKey = key ?? generateKey();
    if (effectiveKey.length != keySize) {
      throw ArgumentError(
        'ChaCha20 key must be exactly $keySize bytes (256 bits). Received ${effectiveKey.length} bytes.',
      );
    }

    final effectiveNonce = nonce ?? _generateNonce();
    if (effectiveNonce.length != nonceSize) {
      throw ArgumentError(
        'ChaCha20 nonce must be exactly $nonceSize bytes (96 bits). Received ${effectiveNonce.length} bytes.',
      );
    }

    final output = Uint8List(nonceSize + audio.length);
    output.setRange(0, nonceSize, effectiveNonce);

    _processChaCha20(
      input: audio,
      inputOffset: 0,
      output: output,
      outputOffset: nonceSize,
      length: audio.length,
      key: effectiveKey,
      nonce: effectiveNonce,
      initialCounter: 1,
    );

    return EncryptionResult(
      encryptedAudio: output,
      key: effectiveKey,
      nonce: effectiveNonce,
    );
  }

  Uint8List decrypt(
    Uint8List encryptedAudio,
    Uint8List key, {
    Uint8List? nonce,
  }) {
    if (key.length != keySize) {
      throw ArgumentError(
        'ChaCha20 key must be exactly $keySize bytes (256 bits). Received ${key.length} bytes.',
      );
    }

    final Uint8List effectiveNonce;
    final int cipherOffset;
    final int cipherLength;

    if (nonce != null) {
      if (nonce.length != nonceSize) {
        throw ArgumentError(
          'ChaCha20 nonce must be exactly $nonceSize bytes (96 bits). Received ${nonce.length} bytes.',
        );
      }
      effectiveNonce = nonce;
      cipherOffset = 0;
      cipherLength = encryptedAudio.length;
    } else {
      if (encryptedAudio.length < nonceSize) {
        throw ArgumentError(
          'Encrypted audio payload is too short: expected at least $nonceSize bytes for the prepended nonce.',
        );
      }
      effectiveNonce = Uint8List.sublistView(encryptedAudio, 0, nonceSize);
      cipherOffset = nonceSize;
      cipherLength = encryptedAudio.length - nonceSize;
    }

    final decrypted = Uint8List(cipherLength);
    _processChaCha20(
      input: encryptedAudio,
      inputOffset: cipherOffset,
      output: decrypted,
      outputOffset: 0,
      length: cipherLength,
      key: key,
      nonce: effectiveNonce,
      initialCounter: 1,
    );

    return decrypted;
  }

  Uint8List _generateNonce() {
    final nonce = Uint8List(nonceSize);
    for (var i = 0; i < nonceSize; i++) {
      nonce[i] = _secureRandom.nextInt(256);
    }
    return nonce;
  }

  static String keyToBase64(Uint8List key) => base64Encode(key);

  static Uint8List keyFromBase64(String base64Key) {
    final bytes = base64Decode(base64Key);
    if (bytes.length != keySize) {
      throw ArgumentError(
        'Invalid key length: expected $keySize bytes, got ${bytes.length}.',
      );
    }
    return bytes;
  }

  static String keyToHex(Uint8List key) =>
      key.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();

  static Uint8List keyFromHex(String hexKey) {
    if (hexKey.length != keySize * 2) {
      throw ArgumentError('Hex key must be exactly ${keySize * 2} characters long.');
    }
    final result = Uint8List(keySize);
    for (var i = 0; i < keySize; i++) {
      result[i] = int.parse(hexKey.substring(i * 2, i * 2 + 2), radix: 16);
    }
    return result;
  }

  static void _processChaCha20({
    required Uint8List input,
    required int inputOffset,
    required Uint8List output,
    required int outputOffset,
    required int length,
    required Uint8List key,
    required Uint8List nonce,
    required int initialCounter,
  }) {
    final keyData = ByteData.sublistView(key);
    final nonceData = ByteData.sublistView(nonce);

    final initialState = Uint32List(16);
    initialState[0] = _c0;
    initialState[1] = _c1;
    initialState[2] = _c2;
    initialState[3] = _c3;

    for (var i = 0; i < 8; i++) {
      initialState[4 + i] = keyData.getUint32(i * 4, Endian.little);
    }
    initialState[13] = nonceData.getUint32(0, Endian.little);
    initialState[14] = nonceData.getUint32(4, Endian.little);
    initialState[15] = nonceData.getUint32(8, Endian.little);

    final working = Uint32List(16);
    final blockBuffer = Uint8List(blockSize);
    final blockData = ByteData.sublistView(blockBuffer);

    var counter = initialCounter & 0xFFFFFFFF;
    var processed = 0;

    while (processed < length) {
      for (var i = 0; i < 16; i++) {
        working[i] = initialState[i];
      }
      working[12] = counter;

      for (var round = 0; round < 10; round++) {
        _quarterRound(working, 0, 4, 8, 12);
        _quarterRound(working, 1, 5, 9, 13);
        _quarterRound(working, 2, 6, 10, 14);
        _quarterRound(working, 3, 7, 11, 15);

        _quarterRound(working, 0, 5, 10, 15);
        _quarterRound(working, 1, 6, 11, 12);
        _quarterRound(working, 2, 7, 8, 13);
        _quarterRound(working, 3, 4, 9, 14);
      }

      for (var i = 0; i < 16; i++) {
        final originalWord = (i == 12) ? counter : initialState[i];
        final sum = (working[i] + originalWord) & 0xFFFFFFFF;
        blockData.setUint32(i * 4, sum, Endian.little);
      }

      final take = (length - processed < blockSize) ? (length - processed) : blockSize;
      for (var i = 0; i < take; i++) {
        output[outputOffset + processed + i] =
            input[inputOffset + processed + i] ^ blockBuffer[i];
      }

      processed += take;
      counter = (counter + 1) & 0xFFFFFFFF;
    }
  }

  static int _rotl32(int v, int n) =>
      ((v << n) | (v >>> (32 - n))) & 0xFFFFFFFF;

  
  static void _quarterRound(
    List<int> s,
    int a,
    int b,
    int c,
    int d,
  ) {
    s[a] = (s[a] + s[b]) & 0xFFFFFFFF;
    s[d] = s[d] ^ s[a];
    s[d] = _rotl32(s[d], 16);

    s[c] = (s[c] + s[d]) & 0xFFFFFFFF;
    s[b] = s[b] ^ s[c];
    s[b] = _rotl32(s[b], 12);

    s[a] = (s[a] + s[b]) & 0xFFFFFFFF;
    s[d] = s[d] ^ s[a];
    s[d] = _rotl32(s[d], 8);

    s[c] = (s[c] + s[d]) & 0xFFFFFFFF;
    s[b] = s[b] ^ s[c];
    s[b] = _rotl32(s[b], 7);
  }
}

