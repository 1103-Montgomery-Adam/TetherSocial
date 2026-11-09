import 'package:flutter/material.dart';
//import'services/CloudflareKeyService.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:tether_social/services/DemoAudioService.dart';
import 'package:tether_social/viewmodels/AudioDemoViewModel.dart';
import 'package:tether_social/views/AudioDemoView.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
    // Initialize the app with the audio demo view
    runApp(
       MaterialApp(
      title: 'Tether',
      home: AudioDemoView(viewModel: AudioDemoViewModel(DemoAudioService())),
    ),
  );
}