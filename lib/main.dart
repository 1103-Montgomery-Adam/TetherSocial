import 'package:flutter/material.dart';
//import'services/CloudflareKeyService.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
    runApp(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text("Hello World, this is Tether:)"),
          ),
        ),
      ),
    );

  
}