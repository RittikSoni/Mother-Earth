import 'package:eco_collect/api/firebase_apis.dart';
import 'package:eco_collect/models/submission_model.dart';
import 'package:flutter/material.dart';

class LeaderboardDataProvider extends ChangeNotifier {
  List<SubmissionModel>? leaderBoardData;

  void fetchLeaderBoardData() async {
    leaderBoardData = await FirebaseApis().fetchAllVerifiedSubmissions();
    notifyListeners();
  }
}
