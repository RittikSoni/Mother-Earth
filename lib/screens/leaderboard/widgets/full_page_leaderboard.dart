import 'package:eco_collect/components/reusable_app_bar.dart';
import 'package:eco_collect/constants/kstrings.dart';
import 'package:eco_collect/constants/ktheme.dart';
import 'package:eco_collect/services/audio_services.dart';

import 'package:eco_collect/utils/common_functions.dart';

import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class FullPageLeaderboard extends StatefulWidget {
  const FullPageLeaderboard(
      {super.key,
      required this.name,
      required this.username,
      required this.messageToWorld,
      required this.taskTitle,
      required this.url});
  final String name;
  final String? taskTitle;
  final String username;
  final String messageToWorld;
  final String url;

  @override
  State<FullPageLeaderboard> createState() => _FullPageLeaderboardState();
}

class _FullPageLeaderboardState extends State<FullPageLeaderboard> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    AudioServices.stopAudio();
    _controller = YoutubePlayerController(
      params: const YoutubePlayerParams(
        showControls: true,
        mute: false,
        showFullscreenButton: true,
        loop: false,
      ),
    )..cueVideoById(
        videoId: Commonfunctions.convertUrlToId(widget.url) ??
            Commonfunctions.convertUrlToId(KStrings.defaultVideoUrl)!,
      );
    _controller.playVideo();
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerScaffold(
      controller: _controller,
      builder: (context, player) {
        return Scaffold(
          appBar: reusableAppBar(title: widget.name),
          body: Column(
            children: [
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    SizedBox(height: 300.0, child: player),
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: KTheme.otherMessageBG,
                        child: Text(widget.name.substring(0, 2).toUpperCase()),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.taskTitle ?? "Mother Earth",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.name,
                            style: const TextStyle(fontSize: 15.0),
                          ),
                        ],
                      ),
                      subtitle: Text('@${widget.username}'),
                    ),
                    ExpansionTile(
                      initiallyExpanded: true,
                      title: Text('Message from ${widget.name}'),
                      childrenPadding:
                          const EdgeInsets.symmetric(horizontal: 16.0),
                      expandedCrossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.messageToWorld),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
