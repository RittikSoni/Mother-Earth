import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_collect/api/firebase_apis.dart';
import 'package:eco_collect/constants/kenums.dart';
import 'package:eco_collect/models/solo_level_model.dart';

import 'package:eco_collect/utils/kloading.dart';
import 'package:flutter/material.dart'; // Import the fetchLevel function

class SoloLevelProvider extends ChangeNotifier {
  List<int>? _levelNumbers;
  List<SoloLevelModel>? _levelsData;

  List<int>? get levelNumbers => _levelNumbers;
  SoloLevelModel? getLevelsData(int levelNumber) {
    try {
      return _levelsData?[levelNumber - 1];
    } catch (_) {}
    return null;
  }

  List<TaskModel>? getLevelTasksData(int levelNumber) {
    try {
      return _levelsData?[levelNumber - 1].tasks;
    } catch (_) {}
    return null;
  }

  Future<void> fetchLevels() async {
    try {
      _levelNumbers = null;
      _levelNumbers = await FirebaseApis.fetchAllLevelNumbers();
      _levelsData = [];
      // Fetch and cache level data for each level number
      for (final levelNumber in _levelNumbers!) {
        final levelsSnapshot = await FirebaseFirestore.instance
            .collection('levels')
            .doc(levelNumber.toString())
            .get();
        final levelTasks =
            await FirebaseApis.fetchLevelTasks(levelNumber.toString());
        _levelsData?.add(
          SoloLevelModel(
            levelNumber: levelNumber,
            tasks: levelTasks,
            dyk: levelsSnapshot.get('dyk'),
            levelTitle: levelsSnapshot.get('levelTitle'),
          ),
        );
      }

      notifyListeners();
    } catch (error) {
      KLoadingToast.showCustomDialog(
          message: 'Somthing went wrong!', toastType: KenumToastType.error);
    }
  }

  void reset() {
    _levelNumbers = [];
    _levelsData = [];
  }
}
