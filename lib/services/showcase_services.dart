import 'package:eco_collect/components/reusable_character_dialogue.dart';
import 'package:eco_collect/constants/kenums.dart';
import 'package:eco_collect/constants/kshowcase_keys.dart';
import 'package:eco_collect/providers/user_provider.dart';
import 'package:eco_collect/routes/kroutes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

class ShowcaseServices {
  void startShowCase({
    required BuildContext context,
    required KenumScreens screen,
  }) {
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      UserDataProvider userProvider =
          Provider.of<UserDataProvider>(context, listen: false);
      bool tempShowTutorial = false;
      bool? isFirstTime = userProvider.isFirstTimeUser;

      if (isFirstTime == true && userProvider.showTutorial == null) {
        await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => ReusableCharacterDialog(
                  onPrimaryPressed: () {
                    Navigator.pop(context);
                    tempShowTutorial = true;
                    userProvider.setShowTutorial = true;
                  },
                  hideSecondary: true,
                  onSecondaryPressed: () {
                    Navigator.pop(context);
                    userProvider.setIsFirstTimeUser = false;
                    userProvider.setShowTutorial = false;
                  },
                ));
        // IS FIRST TIME AND HAVEN'T SHOWED THIS DIALOG YET.
        // await KLoadingToast.showDialogMultipleButtons(
        //     title: 'Welcome to Mother Earth: Start Your Eco-Adventure!',
        //     subtitle:
        //         'Step into the world of Mother Earth, where every choice counts! 🌍✨ Are you ready to begin your eco-adventure?\nStart your journey now by diving into our interactive tutorial!',
        //     widgets: [
        //       Expanded(
        //         child: ReusableButton(
        //           insidePadding: 10.0,
        //           label: 'Skip',
        //           icon: Icons.skip_next_rounded,
        //           onTap: () {
        //             Navigator.pop(context);
        //             userProvider.setIsFirstTimeUser = false;
        //             userProvider.setShowTutorial = false;
        //           },
        //         ),
        //       ),
        //       Commonfunctions.gapMultiplier(
        //           isHorizontal: true, gapMultiplier: 0.2),
        //       Expanded(
        //         child: ReusableButton(
        //           insidePadding: 10.0,
        //           label: 'Let\'s Go!',
        //           icon: Icons.filter_drama_rounded,
        //           onTap: () {
        //             Navigator.pop(context);
        //             tempShowTutorial = true;
        //             userProvider.setShowTutorial = true;
        //           },
        //         ),
        //       ),
        //     ]);
      }
      if (userProvider.showTutorial == true || tempShowTutorial) {
        // IS FIRST TIME AND WANT TO SEE TUTORIAL.
        final keys = getShowCaseKeys(screen: screen);
        if (keys.isNotEmpty) {
          if (context.mounted) {
            ShowCaseWidget.of(context).startShowCase(keys);
          }
        }
      }
    });
  }

  List<GlobalKey<State<StatefulWidget>>> getShowCaseKeys({
    required KenumScreens screen,
  }) {
    UserDataProvider userdateProvider = Provider.of<UserDataProvider>(
        navigatorKey.currentContext!,
        listen: false);
    bool? alredyShowTutorial;
    if (userdateProvider.alreadyShowTutorials != null) {
      alredyShowTutorial = userdateProvider.alreadyShowTutorials!
          .any((element) => element == screen);
    }
    if (alredyShowTutorial == true) {
      return [];
    }
    switch (screen) {
      case KenumScreens.home:
        userdateProvider.setAlreadyShowTutorials = KenumScreens.home;
        return [
          KShowcaseKeys.badge,
          KShowcaseKeys.profile,
          KShowcaseKeys.levels
        ];
      case KenumScreens.submitVideoScreen:
        userdateProvider.setAlreadyShowTutorials =
            KenumScreens.submitVideoScreen;
        return [
          KShowcaseKeys.youtubeLinkField,
          KShowcaseKeys.messageField,
          KShowcaseKeys.beAHeroCheck,
          KShowcaseKeys.submitTaskButton,
        ];
      case KenumScreens.userProfile:
        userdateProvider.setAlreadyShowTutorials = KenumScreens.userProfile;
        return [
          KShowcaseKeys.circleAvatarKey,
          KShowcaseKeys.googleWallet,
        ];

      default:
        return [];
    }
  }
}
