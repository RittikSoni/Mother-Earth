import 'package:flutter/material.dart';

class GameStateProvider extends ChangeNotifier {
  int? bulletsCollected;
  int? lightsCollected;
  int? lightsRequired;

  set addBulletsCollected(int newBulletsCollected) {
    bulletsCollected = (bulletsCollected ?? 0) + newBulletsCollected;
    notifyListeners();
  }

  set deductBulletsCollected(int newBulletsCollected) {
    bulletsCollected = (bulletsCollected ?? 0) - newBulletsCollected;
    notifyListeners();
  }

  set addLightsRequired(int newLightsRequired) {
    lightsRequired = (lightsRequired ?? 0) + newLightsRequired;
    notifyListeners();
  }

  set addLightsCollected(int newLightCollected) {
    lightsCollected = (lightsCollected ?? 0) + newLightCollected;
    notifyListeners();
  }

  void reset() {
    lightsRequired = null;
    lightsCollected = null;
    bulletsCollected = null;

    notifyListeners();
  }
}
