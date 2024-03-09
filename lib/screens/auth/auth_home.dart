import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:eco_collect/components/buttons/reusable_button.dart';
import 'package:eco_collect/components/reusable_bg_image.dart';
import 'package:eco_collect/components/reusable_character_dialogue.dart';
import 'package:eco_collect/constants/kassets.dart';
import 'package:eco_collect/constants/kenums.dart';
import 'package:eco_collect/constants/kstrings.dart';
import 'package:eco_collect/routes/kroutes.dart';
import 'package:eco_collect/screens/auth/widgets/login.dart';
import 'package:eco_collect/screens/auth/widgets/registration.dart';
import 'package:eco_collect/services/audio_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lottie/lottie.dart';

class AuthHome extends StatelessWidget {
  const AuthHome({super.key});

  @override
  Widget build(BuildContext context) {
    kIsWeb ? null : AudioServices.playAudioAccordingToScreen(KenumScreens.auth);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      showDialog(
          context: context,
          builder: (context) => ReusableCharacterDialog(
              title: 'Hey There,👋 Future Eco-Warrior! 🌱',
              message:
                  "In the realm of Mother Earth, heroes are born. I won't spoil the tale until you embark on your journey. Take the first step by joining our cause now to discover your destiny and become the eco-champion this world needs!",
              primaryLabel: 'Begin THE Adventure 🚀',
              onPrimaryPressed: () {
                Navigator.pop(context);
              },
              hideSecondary: true,
              explorerImage: KExplorers.explorer2));
    });

    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          const ReusableBgImage(
            assetImageSource: KLottie.space,
            isLottie: true,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Hero(
                          tag: 'authEarth',
                          child: LottieBuilder.asset(
                            KLottie.earth,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: DefaultTextStyle(
                          style: const TextStyle(
                            fontSize: 55,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                blurRadius: 7.0,
                                color: Colors.white,
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                          child: AnimatedTextKit(
                            repeatForever: true,
                            animatedTexts: [
                              FlickerAnimatedText(KStrings.appTitle),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ReusableButton(
                    label: 'Register',
                    mainAxisAlignment: MainAxisAlignment.center,
                    onTap: () {
                      kIsWeb
                          ? AudioServices.playAudioAccordingToScreen(
                              KenumScreens.auth)
                          : null;

                      KRoute.pushFadeAnimation(
                        context: context,
                        page: const Registration(),
                        durationMilliseconds: 1500,
                      );
                    }),
                ReusableButton(
                    label: 'Login',
                    mainAxisAlignment: MainAxisAlignment.center,
                    onTap: () {
                      kIsWeb
                          ? AudioServices.playAudioAccordingToScreen(
                              KenumScreens.auth)
                          : null;
                      KRoute.pushFadeAnimation(
                        context: context,
                        page: const Login(),
                        durationMilliseconds: 1500,
                      );
                    }),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
