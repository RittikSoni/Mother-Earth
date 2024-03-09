import 'package:eco_collect/api/firebase_apis.dart';
import 'package:eco_collect/constants/kenums.dart';
import 'package:eco_collect/models/submission_model.dart';
import 'package:flutter/foundation.dart';
import '../models/user_data_model.dart';

/// These data will be always available, if user is loggedIn.
class UserDataProvider extends ChangeNotifier {
  bool? isFirstTimeUser;
  bool? showTutorial;
  List<KenumScreens>? alreadyShowTutorials;
  UserDataModel? _userData;
  List<SubmissionTaskModel>? _submissionTaskModel;

  UserDataModel? get getUserData => _userData;
  String? currentUserTempCountry;
  List<SubmissionTaskModel>? get getUserTaskSubmissions => _submissionTaskModel;

  set setCurrentUserTempCountry(KenumPlayerTempCountry newCountry) {
    currentUserTempCountry = newCountry.name;
    notifyListeners();
  }

  Future<void> fetchUserTaskSubmissions() async {
    final fetchedData = await FirebaseApis().fetchUserTaskSubmissions(
        username: _userData != null ? _userData!.username : '');

    _submissionTaskModel = fetchedData;
    notifyListeners();
  }

  set setIsFirstTimeUser(bool isFirstTime) {
    isFirstTimeUser = isFirstTime;
    notifyListeners();
  }

  set setShowTutorial(bool newShowTutorial) {
    showTutorial = newShowTutorial;
    notifyListeners();
  }

  set setAlreadyShowTutorials(KenumScreens screen) {
    alreadyShowTutorials == null
        ? alreadyShowTutorials = [screen]
        : alreadyShowTutorials?.add(screen);
    notifyListeners();
  }

  void setUserData(UserDataModel data) {
    _userData = data;
    notifyListeners();
  }

  void reset() {
    _userData = null;
    currentUserTempCountry = null;
    _submissionTaskModel = null;
    isFirstTimeUser = null;
    showTutorial = null;
    alreadyShowTutorials = null;
    notifyListeners();
  }
}
