import 'package:audioplayers/audioplayers.dart';
import 'package:eco_collect/constants/kdimens.dart';
import 'package:eco_collect/constants/prefs_keys.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioProvider extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();
  double _bgMusicVolume = KDimens.defaultMusicVolume;

  void playSoundForScreen(String soundAsset) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedVolume = prefs.getDouble(KSharedPrefsKeys.audioVolume);
      if (savedVolume == 0.0) {
        await _player.stop();
      } else {
        await _player.stop();
        await _player.play(
          AssetSource(soundAsset),
          volume: _bgMusicVolume,
        );
        _player.setReleaseMode(ReleaseMode.loop);
      }
    } catch (_) {}
  }

  double get getBgMusicVolume {
    if (_bgMusicVolume == 0.0) {
      _player.stop();
      return _bgMusicVolume;
    } else {
      return _bgMusicVolume;
    }
  }

  setBgMusicVolume(double newVol) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.setDouble(KSharedPrefsKeys.audioVolume, newVol);
      if (newVol == 0.0) {
        _player.stop();
        _bgMusicVolume = newVol;
      } else {
        _bgMusicVolume = newVol;
      }
      notifyListeners();
    } catch (_) {}
  }

  void pauseSound() async {
    await _player.pause();
    notifyListeners();
  }

  void stopSound() async {
    await _player.stop();
    notifyListeners();
  }

  void resumeSound() async {
    await _player.resume();
    notifyListeners();
  }

  void reset() {
    _bgMusicVolume = KDimens.defaultMusicVolume;
    notifyListeners();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
