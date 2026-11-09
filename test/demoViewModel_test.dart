//Adam Montgomery
//November 9th, 2026

// import 'package:flutter_test/flutter_test.dart';
// import 'package:tether_social/services/DemoAudioService.dart';
// import 'package:tether_social/viewmodels/AudioDemoViewModel.dart';

//Use "flutter test test/demoViewModel_test.dart" to run these tests

// void main(){
//   test('upload() updates status on success', () async {
//     final service = DemoAudioService(); 
//     final viewModel = AudioDemoViewModel(service);

//     await viewModel.upload();

//     expect(viewModel.isBusy, false);
//     expect(viewModel.status, 'Uploaded "hello_world_demo".');
//   });

//   test('downloadAndPlay() displays errors and updates status', () async {
//   final service = DemoAudioService(); 
//   final viewModel = AudioDemoViewModel(service);
  
//   await viewModel.downloadAndPlay();

//   expect(viewModel.isBusy, false);
//   expect(viewModel.status, 'Nothing to download. Upload first.'); 
// });
// }