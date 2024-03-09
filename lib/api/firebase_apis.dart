import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_collect/constants/error_handler_values.dart';
import 'package:eco_collect/constants/kenums.dart';
import 'package:eco_collect/constants/prefs_keys.dart';
import 'package:eco_collect/models/solo_level_model.dart';
import 'package:eco_collect/models/submission_model.dart';
import 'package:eco_collect/models/user_data_model.dart';
import 'package:eco_collect/providers/audio_provider.dart';
import 'package:eco_collect/providers/game_state_provider.dart';
import 'package:eco_collect/providers/level_provider.dart';
import 'package:eco_collect/providers/message_configs_provider.dart';
import 'package:eco_collect/providers/solo_level_provider.dart';
import 'package:eco_collect/providers/user_provider.dart';
import 'package:eco_collect/routes/kroutes.dart';
import 'package:eco_collect/screens/auth/auth_home.dart';
import 'package:eco_collect/utils/error_handler.dart';
import 'package:eco_collect/utils/kloading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseApis {
  factory FirebaseApis() {
    return _customFirebaseApis;
  }
  FirebaseApis._internal();
  static final FirebaseApis _customFirebaseApis = FirebaseApis._internal();

// #############################################################################

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  static const String mustField =
      'This is random field in-order to prevent empty doc mark. Italic name means that doc is empty as their is no field, as subcollection are not counted.';

  /// Whenever we create a new `document` from code which it contains only `subcollection`
  /// and not any field it will be marked as `empty` (italic) and this will
  /// prevent us to `read/fetch` that `data/doc` as it is marked as empty
  /// from firestore, so in-order to prevent this behaviour either add a random
  /// `field` to `doc` or just add same name doc from firebase console.
  Future<void> _addMustFieldIfDocContainsOnlySubCollection(
      {required String docPath}) async {
    await firestore.doc(docPath).set({
      'readme': mustField,
      'forMoreInfo':
          'https://firebase.google.com/docs/firestore/using-console?hl=en&authuser=0&_gl=1*1alzu52*_ga*ODYwNzgwODAyLjE2ODg2NTU4NDc.*_ga_CW55HF8NVT*MTcwMDM3MjM1Ny4xMzYuMS4xNzAwMzg3MTM3LjYwLjAuMA..#non-existent_ancestor_documents'
    });
  }

// #############################################################################

  Future<String> registerFirebase({
    required BuildContext context,
    required String fullName,
    required String username,
    required String emailAddress,
    required String password,
    required String country,
  }) async {
    try {
      KLoadingToast.startLoading();
      final UserCredential credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailAddress, password: password);

      if (credential.user != null) {
        final bool isUnique =
            await isUsernameAndEmailUnique(username, emailAddress);

        if (isUnique) {
          // Create a batch for Firestore writes
          final WriteBatch batch = FirebaseFirestore.instance.batch();

          // PREVENT ITALIC DOC (EMPTY DOC), SO JUST ADD RANDOM FIELD
          _addMustFieldIfDocContainsOnlySubCollection(
              docPath: 'users/endUsers');

          // Create a new user document in Firestore
          final DocumentReference userDocRef =
              firestore.doc('users/endUsers/endUsersData/$username');
          batch.set(userDocRef, {
            'fullName': fullName,
            'username': username,
            'email': emailAddress,
            'trophies': 0,
            'xp': 0,
            'country': country,
            'isBanned': false,
            'banReason': '',
            'createdAt': DateTime.now().toLocal().toIso8601String(),
            'updatedAt': DateTime.now().toLocal().toIso8601String(),
          });

          // Commit the batch
          await batch.commit();

          final UserDataProvider userData = Provider.of<UserDataProvider>(
              navigatorKey.currentContext!,
              listen: false);

          final UserDataModel userDataModel = UserDataModel(
            fullName: fullName,
            username: username,
            email: emailAddress,
            country: country,
            isBanned: false,
            trophies: 0,
            xp: 0,
            banReason: '',
            createdAt: DateTime.now().toLocal(),
            updatedAt: DateTime.now().toLocal(),
          );
          userData.setUserData(
            userDataModel,
          );

          final Map<String, dynamic> userJsonData = userDataModel.toJson();
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString(
              KSharedPrefsKeys.userData, jsonEncode(userJsonData));
          await prefs.setBool(KSharedPrefsKeys.isValidUser, true);

          return ErrorsHandlerValues.goodToRegister;
        } else {
          // If the username or email is not unique, delete the created user
          await credential.user?.delete();
          return ErrorsHandlerValues.usernameEmailNotUnique;
        }
      }
      return ErrorsHandlerValues.registrationFailed;
    } on FirebaseAuthException catch (e, stack) {
      if (e.code == 'email-already-in-use') {
        ErrorHandler.defaultCatchError(
          e: e,
          errorCode: 'RS1xJSK12',
          stackTrace: stack,
          customToastMessage: ErrorsHandlerValues.emailInUse,
        );
        return ErrorsHandlerValues.emailInUse;
      } else {
        ErrorHandler.defaultCatchError(
            e: e,
            errorCode: 'RS1xJSK12',
            stackTrace: stack,
            customToastMessage: ErrorsHandlerValues.registrationFailed);
        return ErrorsHandlerValues
            .registrationFailed; // Use a custom error code.
      }
    } finally {
      KLoadingToast.stopLoading();
    }
  }

  Future<bool> isUsernameAndEmailUnique(String username, String email) async {
    final QuerySnapshot<Map<String, dynamic>> endUsersData = await firestore
        .collection('users/endUsers/endUsersData')
        .where('username', isEqualTo: username)
        .get();

    if (endUsersData.docs.isNotEmpty) {
      KLoadingToast.showCustomDialog(
        message: 'Username already exist',
        toastType: KenumToastType.error,
      );
      return false; // Username is not unique
    }

    final QuerySnapshot<Map<String, dynamic>> emailData = await firestore
        .collection('users/endUsers/endUsersData')
        .where('email', isEqualTo: email)
        .get();

    return emailData.docs.isEmpty;
  }

  Future<String> loginFirebase({
    required BuildContext context,
    required String username,
    required String emailAddress,
    required String password,
  }) async {
    try {
      final UserCredential credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailAddress, password: password);

      if (credential.user != null) {
        try {
          final QuerySnapshot<Map<String, dynamic>> endUsersData =
              await firestore
                  .doc('users/endUsers')
                  .collection('endUsersData')
                  .get();

          bool isUsernameExist = false;
          QueryDocumentSnapshot<Map<String, dynamic>>? userDocument;

          // Loop through user documents and check in 'enduserdata' collection
          for (final QueryDocumentSnapshot<Map<String, dynamic>> userDoc
              in endUsersData.docs) {
            final String userId = userDoc.id;
            isUsernameExist =
                userId == username && userDoc.get('email') == emailAddress;

            if (isUsernameExist) {
              userDocument = userDoc;
              break;
            }
          }

          final isUserBanned = userDocument?.get('isBanned');

          if (isUserBanned == true) {
            return ErrorsHandlerValues.bannedUser;
          }

          if (isUsernameExist && isUserBanned == false) {
            final DateTime finalCreatedAt2 =
                DateTime.parse(userDocument?.get('createdAt'));
            final DateTime finalUpdateAt2 =
                DateTime.parse(userDocument?.get('updatedAt'));

            if (!context.mounted) {
              return ErrorsHandlerValues.contextNotMounted;
            }
            final UserDataProvider userData =
                Provider.of<UserDataProvider>(context, listen: false);

            final UserDataModel userDataModel = UserDataModel(
              fullName: userDocument?.get('fullName'),
              username: userDocument?.get('username'),
              email: userDocument?.get('email'),
              country: userDocument?.get('country'),
              isBanned: userDocument?.get('isBanned'),
              banReason: userDocument?.get('banReason'),
              xp: userDocument?.get('xp'),
              trophies: userDocument?.get('trophies'),
              createdAt: finalCreatedAt2,
              updatedAt: finalUpdateAt2,
            );
            userData.setUserData(
              userDataModel,
            );

            final Map<String, dynamic> userJsonData = userDataModel.toJson();
            final SharedPreferences prefs =
                await SharedPreferences.getInstance();
            await prefs.setString(
                KSharedPrefsKeys.userData, jsonEncode(userJsonData));
            await prefs.setBool(KSharedPrefsKeys.isValidUser, true);
            return ErrorsHandlerValues.goodToLogin;
          }
          return ErrorsHandlerValues.usernameInvalid;
        } catch (e) {
          return 'Error during username check $e';
        }
      }
      await KLoadingToast.showCustomDialog(
        message: credential.user.toString(),
        toastType: KenumToastType.info,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return ErrorsHandlerValues.passOrEmailInvalid;
      } else if (e.code == 'wrong-password') {
        return ErrorsHandlerValues.passOrEmailInvalid;
      } else if (e.toString().contains('INVALID_LOGIN_CREDENTIALS') ||
          e.toString().contains('invalid-credential')) {
        return ErrorsHandlerValues.passOrEmailInvalid;
      } else if (e.toString().contains(
          '[firebase_auth/invalid-email] The email address is badly formatted')) {
        return ErrorsHandlerValues.passOrEmailInvalid;
      } else {
        return 'Something went wrong during login $e';
      }
    }
    return 'Something went wrong during login process.';
  }

  /// WARNING!: This will only sign out from firebase, make sure to clear prefs & provider
  /// data.
  Future<void> signOutFirebase() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e, stack) {
      ErrorHandler.defaultCatchError(
          e: e, errorCode: 'RS1xidsaf1', stackTrace: stack);
    }
  }

  Future<dynamic> fetchLatestUserData({
    required BuildContext context,
    required String username,
    required String emailAddress,
  }) async {
    try {
      KLoadingToast.startLoading();

      final QuerySnapshot<Map<String, dynamic>> endUsersData = await firestore
          .doc('users/endUsers')
          .collection('endUsersData')
          .get();

      bool isUsernameExist = false;
      QueryDocumentSnapshot<Map<String, dynamic>>? userDocument;

      // Loop through user documents and check in 'enduserdata' collection
      for (final QueryDocumentSnapshot<Map<String, dynamic>> userDoc
          in endUsersData.docs) {
        final String userId = userDoc.id;
        isUsernameExist =
            userId == username && userDoc.get('email') == emailAddress;

        if (isUsernameExist) {
          userDocument = userDoc;
          break;
        }
      }
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      final DateTime finalCreatedAt2 =
          DateTime.parse(userDocument?.get('createdAt'));
      final DateTime finalUpdateAt2 =
          DateTime.parse(userDocument?.get('updatedAt'));

      if (!context.mounted) {
        return ErrorsHandlerValues.contextNotMounted;
      }
      final UserDataProvider userData =
          Provider.of<UserDataProvider>(context, listen: false);
      final UserDataModel userDataModel = UserDataModel(
        fullName: userDocument?.get('fullName'),
        username: userDocument?.get('username'),
        email: userDocument?.get('email'),
        country: userDocument?.get('country'),
        isBanned: userDocument?.get('isBanned'),
        banReason: userDocument?.get('banReason'),
        xp: userDocument?.get('xp'),
        trophies: userDocument?.get('trophies'),
        createdAt: finalCreatedAt2,
        updatedAt: finalUpdateAt2,
      );
      userData.setUserData(
        userDataModel,
      );
      final Map<String, dynamic> userJsonData = userDataModel.toJson();
      await prefs.setString(
          KSharedPrefsKeys.userData, jsonEncode(userJsonData));
      await prefs.setBool(KSharedPrefsKeys.isValidUser, true);
      return userDataModel;
    } catch (e, stack) {
      ErrorHandler.defaultCatchError(
          e: e, errorCode: 'RS1x2134', stackTrace: stack);
    } finally {
      KLoadingToast.stopLoading();
    }
  }

  Future<UserDataModel> getSavedUserData(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      final String? userData = prefs.getString(KSharedPrefsKeys.userData);
      if (userData != null) {
        if (context.mounted) {
          final UserDataProvider user =
              Provider.of<UserDataProvider>(context, listen: false);
          if (user.getUserData == null || user.getUserData?.username == '') {
            user.setUserData(
              UserDataModel.fromJson(
                jsonDecode(userData) as Map<String, dynamic>,
              ),
            );
          }
        }
        return UserDataModel.fromJson(
            jsonDecode(userData) as Map<String, dynamic>);
      } else {
        return UserDataModel(
          username: '',
          email: '',
          fullName: '',
          country: '',
          isBanned: false,
          banReason: '',
          trophies: 0,
          xp: 0,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
      }
    } catch (e) {
      throw Exception('Something went wrong');
    }
  }

  static Future<void> logout() async {
    try {
      KLoadingToast.startLoading();
      final BuildContext context = navigatorKey.currentContext!;

      final UserDataProvider userProvider =
          Provider.of<UserDataProvider>(context, listen: false);
      final LevelProvider levelProvider =
          Provider.of<LevelProvider>(context, listen: false);
      final AudioProvider audioProvider =
          Provider.of<AudioProvider>(context, listen: false);
      final SoloLevelProvider soloLevelProvider =
          Provider.of<SoloLevelProvider>(context, listen: false);
      final MessageConfigProvider messageConfigProvider =
          Provider.of<MessageConfigProvider>(context, listen: false);
      final GameStateProvider gameStateProvider =
          Provider.of<GameStateProvider>(context, listen: false);

      // Resetting all providers
      userProvider.reset();
      gameStateProvider.reset();
      levelProvider.reset();
      audioProvider.reset();
      soloLevelProvider.reset();
      messageConfigProvider.reset();

      // Resetting prefs
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // Signing out from firebase auth
      await FirebaseAuth.instance.signOut();

      // Routing to Auth home
      context.mounted
          ? KRoute.pushRemove(context: context, page: const AuthHome())
          : null;
    } catch (e) {
      KLoadingToast.showCustomDialog(message: 'Something went wrong.');
    } finally {
      KLoadingToast.stopLoading();
    }
  }

  static Future<List<int>> fetchAllLevelNumbers() async {
    try {
      List<int> levelNumbers;
      final levelsSnapshot = await FirebaseFirestore.instance
          .collection('levels')
          .orderBy('levelNumber')
          .get();
      levelNumbers =
          levelsSnapshot.docs.map((doc) => doc['levelNumber'] as int).toList();
      return levelNumbers;
    } catch (error) {
      throw Exception('Somthing went wrong.$error');
    }
  }

  static Future<List<TaskModel>> fetchLevelTasks(String levelId) async {
    try {
      final levelDoc = await FirebaseFirestore.instance
          .collection('levels')
          .doc(levelId)
          .collection('tasks')
          .get();
      final levelData = levelDoc.docs;

      List<TaskModel> tasksList = [];
      for (var task in levelData) {
        tasksList.add(TaskModel.fromJson(task.data()));
      }
      return tasksList;
    } catch (error) {
      throw Exception('Failed to fetch level: $error');
    }
  }

  Future<List<SubmissionTaskModel>> fetchUserTaskSubmissions(
      {required String username}) async {
    try {
      KLoadingToast.startLoading();
      final levelDoc = await firestore
          .collection('submissions')
          .doc(username)
          .collection('tasks')
          .get();

      final levelData = levelDoc.docs;

      List<SubmissionTaskModel> tasksList = [];
      for (var task in levelData) {
        tasksList.add(SubmissionTaskModel.fromJson(task.data()));
      }
      return tasksList;
    } catch (error) {
      return [];
    } finally {
      KLoadingToast.stopLoading();
    }
  }

  Future<void> submitTask({
    required TaskModel task,
    required SubmissionTaskModel submissionTaskDetails,
  }) async {
    try {
      KLoadingToast.startLoading();
      final UserDataProvider userProvider = Provider.of<UserDataProvider>(
          navigatorKey.currentContext!,
          listen: false);
      final String? username = userProvider.getUserData?.username;
      final String? name = userProvider.getUserData?.fullName;
      await firestore
          .collection('submissions')
          .doc(username)
          .set({'username': username, 'name': name});
      await firestore
          .collection('submissions')
          .doc(username)
          .collection('tasks')
          .doc(task.taskId)
          .set(
            submissionTaskDetails.toJson(),
          );
      await userProvider.fetchUserTaskSubmissions();
    } catch (error) {
      throw Exception('Failed to fetch level: $error');
    } finally {
      KLoadingToast.stopLoading();
    }
  }

  Future<List<SubmissionModel>> fetchAllVerifiedSubmissions() async {
    final submissions = await firestore.collection('submissions').get();
    List<SubmissionModel> submissionList = [];
    for (var submission in submissions.docs) {
      String username = submission.id;
      String name = submission.get('name');

      // Query 'tasks' subcollection for the current username
      QuerySnapshot tasksQuery = await firestore
          .collection('submissions')
          .doc(username)
          .collection('tasks')
          .where('status', isEqualTo: KenumSubmissionStatus.verified.name)
          .where('isPublic', isEqualTo: true)
          .get();

      // Check if 'tasks' subcollection exists for the current username
      if (tasksQuery.docs.isNotEmpty) {
        for (QueryDocumentSnapshot task in tasksQuery.docs) {
          submissionList.add(
            SubmissionModel(
              tasks: [
                SubmissionTaskModel.fromJson(
                    task.data() as Map<String, dynamic>)
              ],
              username: username,
              name: name,
            ),
          );
        }
      }
    }
    return submissionList;
  }
}
