// ignore_for_file: body_might_complete_normally_catch_error

import 'package:eco_collect/components/error_app.dart';
import 'package:eco_collect/components/no_internet_screen.dart';
import 'package:eco_collect/firebase_options.dart';
import 'package:eco_collect/my_game.dart';
import 'package:eco_collect/services/connectivity_services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  // runApp(const MyGame());

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // CHECK INTERNET CONNECTIVIT
  final hasInternet =
      await ConnectivityServices().checkInternetConnectivity().catchError((_) {
    runApp(const ErrorApp());
  });

  if (hasInternet) {
    // HAS INTERNET ACCESS

    // Initialize Firebase Messaging for push notifications.
    final FirebaseMessaging messaging = FirebaseMessaging.instance;
    if (!kIsWeb) {
      // Subscribe to the desired topic for notifications.
      await messaging.subscribeToTopic("motherEarth");
    }

    runApp(const MyGame());
  } else {
    // NO INTERNET

    runApp(const NoInternetScreen());
  }
}
