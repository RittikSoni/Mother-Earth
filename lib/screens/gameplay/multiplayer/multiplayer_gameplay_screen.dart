import 'package:eco_collect/components/reusable_app_bar.dart';
import 'package:eco_collect/constants/kenums.dart';
import 'package:eco_collect/services/audio_services.dart';
import 'package:flutter/material.dart';

class MultiplayerGameplayScreen extends StatelessWidget {
  const MultiplayerGameplayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AudioServices.playAudioAccordingToScreen(KenumScreens.multiplayer);
    String title = 'Multiplayer';
    return Scaffold(
      appBar: reusableAppBar(title: title),
      body: Column(
        children: [
          Text(title),
        ],
      ),
    );
  }
}
