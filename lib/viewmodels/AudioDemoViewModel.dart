//Elijah Gutierrez 11/8/2026

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:tether_social/services/DemoAudioService.dart';

class AudioDemoViewModel extends ChangeNotifier {
  final DemoAudioService _service;
  final AudioPlayer _player = AudioPlayer();

  static const String demoAssetPath = 'assets/audio/hello_world.mp3';
  static const String demoPostId = 'hello_world_demo';

  bool isBusy = false;
  String status = 'Ready. Nothing uploaded yet.';

  AudioDemoViewModel(this._service);

  Future<void> upload() => _run('Uploading...', () async {
        final data = await rootBundle.load(demoAssetPath);
        await _service.upload(trackId: demoPostId, audio: data.buffer.asUint8List());
        return 'Uploaded "$demoPostId".';
      });

  Future<void> downloadAndPlay() => _run('Downloading...', () async {
        final audio = await _service.download(trackId: demoPostId);
        if (audio == null) {
          return 'Nothing to download. Upload first.';
        }
        await _player.stop();
        await _player.play(BytesSource(audio, mimeType: 'audio/mpeg'));
        return 'Downloaded and playing "$demoPostId".';
      });

  Future<void> delete() => _run('Deleting...', () async {
        await _player.stop();
        await _service.delete(trackId: demoPostId);
        return 'Deleted "$demoPostId".';
      });

  Future<void> _run(String busyMessage, Future<String> Function() action) async {
    if (isBusy) return;
    isBusy = true;
    status = busyMessage;
    notifyListeners();
    try {
      status = await action();
    } catch (e) {
      status = 'Error: $e';
    } finally {
      isBusy = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
