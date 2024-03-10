import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eco_collect/api/firebase_apis.dart';
import 'package:eco_collect/components/error_app.dart';
import 'package:eco_collect/constants/kstrings.dart';
import 'package:eco_collect/constants/ktheme.dart';
import 'package:eco_collect/main.dart';

import 'package:eco_collect/models/user_data_model.dart';
import 'package:eco_collect/providers/audio_provider.dart';
import 'package:eco_collect/providers/game_state_provider.dart';
import 'package:eco_collect/providers/leaderboard_data_provider.dart';
import 'package:eco_collect/providers/level_provider.dart';
import 'package:eco_collect/providers/message_configs_provider.dart';
import 'package:eco_collect/providers/solo_level_provider.dart';
import 'package:eco_collect/providers/user_provider.dart';
import 'package:eco_collect/routes/kroutes.dart';
import 'package:eco_collect/screens/auth/auth_home.dart';
import 'package:page_transition/page_transition.dart';

import 'package:eco_collect/screens/global/global_bottom_nav.dart';
import 'package:eco_collect/utils/common_functions.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyGame extends StatelessWidget {
  const MyGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LeaderboardDataProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => MessageConfigProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => UserDataProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => LevelProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AudioProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => SoloLevelProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => GameStateProvider(),
        ),
      ],
      builder: (context, child) => MaterialApp(
        title: KStrings.appTitle,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        builder: BotToastInit(),
        navigatorObservers: [BotToastNavigatorObserver()],
        theme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: KTheme.globalScaffoldBG,
            appBarTheme: const AppBarTheme(
              backgroundColor: KTheme.globalAppBarBG,
            ),
            inputDecorationTheme: const InputDecorationTheme(
              fillColor: KTheme.transparencyBlack,
              errorStyle:
                  TextStyle(color: KTheme.error, fontWeight: FontWeight.bold),
            ),
            dialogTheme: const DialogTheme(
              backgroundColor: KTheme.globalScaffoldBG,
            )),
        navigatorKey: navigatorKey,
        home: AnimatedSplashScreen(
          backgroundColor: Colors.black,
          splash: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.headphones_rounded,
                  color: Colors.white,
                ),
                Commonfunctions.gapMultiplier(),
                Text(
                  'Use headphones for better experience'.toUpperCase(),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          nextScreen: const MainGameEntry(),
          duration: 3000,
          splashTransition: SplashTransition.fadeTransition,
          pageTransitionType: PageTransitionType.fade,
        ),
      ),
    );
  }
}

class MainGameEntry extends StatelessWidget {
  const MainGameEntry({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserDataModel>(
      future: FirebaseApis().getSavedUserData(context),
      builder: (BuildContext context, AsyncSnapshot<UserDataModel> snapshot) {
        if (snapshot.hasError) {
          return ErrorApp(
            onRetry: () async {
              await FirebaseApis.logout();
              main();
            },
            retryLabel: 'Re-login',
          );
        } else if (!snapshot.hasData ||
            snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.data!.username != '') {
          /// LOGGED IN USER

          return const GlobalBottomNav();
        }

        return const AuthHome();
      },
    );
  }
}
