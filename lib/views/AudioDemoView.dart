//Elijah Gutierrez 11/8/2026

import 'package:flutter/material.dart';
import 'package:tether_social/viewmodels/AudioDemoViewModel.dart';

class AudioDemoView extends StatelessWidget {
  final AudioDemoViewModel viewModel;
  const AudioDemoView({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tether Demo')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: ListenableBuilder(
            listenable: viewModel,
            builder: (context, child) {
              final busy = viewModel.isBusy;
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FilledButton.icon(
                    onPressed: busy ? null : viewModel.upload,
                    icon: const Icon(Icons.upload),
                    label: const Text('Upload audio'),
                  ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: busy ? null : viewModel.downloadAndPlay,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Download and play audio'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: busy ? null : viewModel.delete,
                    icon: const Icon(Icons.delete),
                    label: const Text('Delete audio'),
                  ),
                  const SizedBox(height: 24),
                  if (busy) const LinearProgressIndicator(),
                  const SizedBox(height: 8),
                  Text(viewModel.status, textAlign: TextAlign.center),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
