import 'package:eco_collect/constants/kassets.dart';
import 'package:eco_collect/constants/kdimens.dart';
import 'package:eco_collect/constants/kenums.dart';
import 'package:eco_collect/constants/prefs_keys.dart';
import 'package:eco_collect/providers/audio_provider.dart';
import 'package:eco_collect/routes/kroutes.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioServices {
  static void stopAudio() {
    final audioProvider =
        Provider.of<AudioProvider>(navigatorKey.currentContext!, listen: false);
    audioProvider.stopSound();
  }

  static void playAudioAccordingToScreen(KenumScreens screen) async {
    final String music;
    double? volume;

    final audioProvider =
        Provider.of<AudioProvider>(navigatorKey.currentContext!, listen: false);

    switch (screen) {
      case KenumScreens.auth:
        music = KMusic.auth;
      case KenumScreens.miniGames:
        music = KMusic.magicTree;

      case KenumScreens.home:
        music = KMusic.seaAndSeaeagle;
      case KenumScreens.gChat:
        music = KMusic.birdsSound;
        volume = 0.3;

      case KenumScreens.hero:
        music = KMusic.hero;
      case KenumScreens.explore:
        music = KMusic.explore;
      case KenumScreens.tier:
        music = KMusic.tier;
      case KenumScreens.solo:
        music = KMusic.solo;
      case KenumScreens.multiplayer:
        music = KMusic.tier;
      case KenumScreens.userProfile:
        music = KMusic.auth;
      case KenumScreens.settings:
        music = KMusic.seaAndSeaeagle;

      default:
        music = KMusic.seaAndSeaeagle;
    }

    final prefs = await SharedPreferences.getInstance();
    final savedVolume = prefs.getDouble(KSharedPrefsKeys.audioVolume);
    if (savedVolume == 0.0) {
      // DO nothing with volume.
    } else {
      if (audioProvider.getBgMusicVolume == KDimens.defaultMusicVolume) {
        // User has not changed the volume, so now we can adjust volume accordingly.
        if (volume != null) {
          audioProvider.setBgMusicVolume(volume);
        } else {
          audioProvider.setBgMusicVolume(KDimens.defaultMusicVolume);
        }
      }
    }

    audioProvider.playSoundForScreen(music);
  }
}
