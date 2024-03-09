import 'package:eco_collect/components/buttons/reusable_button.dart';
import 'package:eco_collect/components/reusable_bg_image.dart';
import 'package:eco_collect/components/reusable_loop_animation.dart';
import 'package:eco_collect/constants/kassets.dart';
import 'package:eco_collect/constants/kdimens.dart';
import 'package:eco_collect/providers/audio_provider.dart';
import 'package:eco_collect/providers/user_provider.dart';
import 'package:eco_collect/routes/kroutes.dart';
import 'package:eco_collect/screens/gameplay/solo/solo_gameplay_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  double _offsetY = 1.0;
  Animation<double>? _dolphinController;

  late AudioProvider audioService;

  @override
  void initState() {
    super.initState();

    _dolphinController =
        AnimationController(vsync: this, duration: const Duration(seconds: 8))
          ..forward()
          ..repeat();

    audioService = Provider.of<AudioProvider>(context, listen: false);

    // Start the animation when the widget is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserDataProvider>(context, listen: false)
          .fetchUserTaskSubmissions();
      _startAnimation();
      audioService.playSoundForScreen(KMusic.seaAndSeaeagle);
    });
  }

  // Function to start the animation
  void _startAnimation() {
    setState(() {
      _offsetY = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Stack(
      clipBehavior: Clip.none,
      fit: StackFit.passthrough,
      children: [
        const ReusableBgImage(
          assetImageSource: KImages.sea2,
          // assetImageSource: KImages.sea2,
        ),
        const ReusableLoopAnimation(
          deltaX: 50,
          child: ReusableBgImage(
            assetImageSource: KImages.cloud,
            boxFit: BoxFit.contain,
          ),
        ),
        const ReusableLoopAnimation(
          deltaX: -50,
          child: ReusableBgImage(
            assetImageSource: KImages.cloud,
            height: 200.0,
            width: 250.0,
          ),
        ),
        Positioned(
          left: KDimens.screenWidth / 2,
          bottom: KDimens.screenHeight / 2,
          child: AnimatedContainer(
            duration: const Duration(seconds: 2),
            curve: Curves.easeInOut,
            transform: Matrix4.translationValues(
                0, _offsetY * MediaQuery.of(context).size.height, 0),
            child: const ReusableBgImage(
              assetImageSource: KLottie.coconutTree,
              isLottie: true,
              height: 100.0,
            ),
          ),
        ),
        Positioned(
          right: KDimens.screenWidth / 2.5,
          bottom: KDimens.screenHeight / 2.5,
          child: AnimatedContainer(
            duration: const Duration(seconds: 2),
            curve: Curves.easeInOut,
            transform: Matrix4.translationValues(
                0, _offsetY * MediaQuery.of(context).size.height, 0),
            child: const ReusableBgImage(
              assetImageSource: KLottie.coconutTree,
              isLottie: true,
              height: 100.0,
            ),
          ),
        ),
        Center(
          child: LottieBuilder.asset(
            KLottie.dolphinPurple,
            controller: _dolphinController,
            height: 100.0,
            width: 100.0,
          ),
        ),
        Center(
          child: LottieBuilder.asset(
            KLottie.dolphinSky,
            controller: _dolphinController,
            height: 100.0,
            width: 100.0,
          ),
        ),
        Positioned(
          left: 10.0,
          bottom: 10.0,
          top: 10.0,
          child: LottieBuilder.asset(
            KLottie.islandYellow,
            height: 100.0,
            width: 100.0,
          ),
        ),
        Positioned(
          bottom: 100.0,
          left: 100.0,
          right: 100.0,
          child: LottieBuilder.asset(
            controller: _dolphinController,
            KLottie.dolphinSky,
            height: 100.0,
            width: 100.0,
          ),
        ),
        LottieBuilder.asset(KLottie.birds),
        LottieBuilder.asset(KLottie.parrots),
        AnimatedContainer(
          duration: const Duration(seconds: 2),
          curve: Curves.easeInOut,
          transform: Matrix4.translationValues(
              0, _offsetY * MediaQuery.of(context).size.height, 0),
          child: const ReusableBgImage(
            assetImageSource: KImages.pineTrees,
          ),
        ),
        Column(
          children: [
            ReusableButton(
              label: 'Solo',
              icon: Icons.energy_savings_leaf_rounded,
              fg: const Color.fromRGBO(255, 255, 255, 1),
              onTap: () async {
                await Provider.of<UserDataProvider>(context, listen: false)
                    .fetchUserTaskSubmissions();
                KRoute.push(
                    context: navigatorKey.currentContext!,
                    page: const SoloGameplayScreen());
              },
            ),
          ],
        ),
      ],
    ));
  }
}
