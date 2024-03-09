import 'package:chewie/chewie.dart';
import 'package:eco_collect/components/buttons/reusable_button.dart';
import 'package:eco_collect/components/reusable_character_dialogue.dart';
import 'package:eco_collect/constants/kassets.dart';
import 'package:eco_collect/constants/kdimens.dart';
import 'package:eco_collect/constants/ktheme.dart';
import 'package:eco_collect/routes/kroutes.dart';
import 'package:eco_collect/screens/global/global_bottom_nav.dart';
import 'package:eco_collect/services/audio_services.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:video_player/video_player.dart';

class MotherEarthVideo extends StatefulWidget {
  const MotherEarthVideo({
    Key? key,
    this.showSkipWarning = true,
  }) : super(key: key);

  /// Default is `true`
  final bool? showSkipWarning;

  @override
  State<StatefulWidget> createState() {
    return _MotherEarthVideoState();
  }
}

class _MotherEarthVideoState extends State<MotherEarthVideo> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  Future<void> initializePlayer() async {
    await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeRight],
    );

    _videoPlayerController = VideoPlayerController.asset(KVideos.motherEarth);
    await Future.wait([
      _videoPlayerController.initialize(),
    ]);

    _videoPlayerController.addListener(() {
      if (_videoPlayerController.value.isCompleted) {
        _onSkipTap(showWarning: false);
      }
    });

    _createChewieController();
    setState(() {});
  }

  void _createChewieController() {
    _chewieController?.enterFullScreen();
    _chewieController = ChewieController(
      fullScreenByDefault: true,
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: false,
      allowFullScreen: true,
      deviceOrientationsOnEnterFullScreen: [
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft
      ],
      aspectRatio: kIsWeb
          ? MediaQuery.of(context).size.width /
              MediaQuery.of(context).size.height
          : KDimens.screenWidth / (KDimens.screenHeight / 1.1),
      zoomAndPan: true,
      showControls: false,
      allowMuting: false,
      allowedScreenSleep: false,
      showOptions: false,
      overlay: Align(
        alignment: Alignment.topRight,
        child: FutureBuilder(
            future: Future.delayed(const Duration(seconds: 10)),
            builder: (context, snampshot) {
              if (snampshot.connectionState == ConnectionState.waiting) {
                return Container();
              }
              return ReusableButton(
                  width: 70.0,
                  insidePadding: 2.0,
                  label: 'Skip',
                  icon: Icons.skip_next_rounded,
                  bg: KTheme.transparencyBlack,
                  onTap: () async {
                    await _onSkipTap(showWarning: widget.showSkipWarning);
                  });
            }),
      ),
    );
    setState(() {
      _chewieController?.enterFullScreen();
    });
  }

  @override
  Widget build(BuildContext context) {
    AudioServices.stopAudio();

    return PopScope(
      canPop: false,
      child: Scaffold(
          backgroundColor: Colors.black,
          body: Stack(children: <Widget>[
            _chewieController != null
                ? Chewie(
                    controller: _chewieController!,
                  )
                : Container(),
          ])),
    );
  }

  _onSkipTap({bool? showWarning = true}) async {
    if (showWarning == true) {
      showDialog(
          context: context,
          builder: (context) => ReusableCharacterDialog(
                explorerImage: KExplorers.explorer3,
                title: 'Skip',
                message:
                    "Are you sure you want to skip the cinematic video? It adds depth to the game experience and helps immerse you in the story. Skipping it may detract from your overall enjoyment.",
                primaryLabel: 'Skip Anyway.',
                onPrimaryPressed: () async {
                  await SystemChrome.setPreferredOrientations(
                    [
                      DeviceOrientation.portraitUp,
                      DeviceOrientation.portraitDown
                    ],
                  );
                  KRoute.pushRemove(
                      context: navigatorKey.currentContext!,
                      page: const GlobalBottomNav());
                },
                secondaryLabel: 'Cancel',
                onSecondaryPressed: () {
                  Navigator.pop(context);
                },
              ));
      // KLoadingToast.showCustomDialog(
      //   message:
      //       'You are going to Skip, we do not recommend this action, are you sure?',
      //   buttonLabel: 'Skip',
      //   onTap: () async {
      //     await SystemChrome.setPreferredOrientations(
      //       [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
      //     );
      //     KRoute.pushRemove(
      //         context: navigatorKey.currentContext!,
      //         page: const GlobalBottomNav());
      //   },
      // );
    } else {
      await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
      );
      KRoute.pushRemove(
          context: navigatorKey.currentContext!, page: const GlobalBottomNav());
    }
  }
}
