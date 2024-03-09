import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_collect/components/reusable_bg_image.dart';
import 'package:eco_collect/components/reusable_textformfield.dart';
import 'package:eco_collect/constants/kassets.dart';
import 'package:eco_collect/constants/kenums.dart';
import 'package:eco_collect/constants/kstrings.dart';
import 'package:eco_collect/constants/ktheme.dart';
import 'package:eco_collect/models/g_chat_user_model.dart';
import 'package:eco_collect/providers/message_configs_provider.dart';
import 'package:eco_collect/providers/user_provider.dart';
import 'package:eco_collect/screens/gchat/widgets/message_bubble.dart';
import 'package:eco_collect/screens/gchat/widgets/messages_builder.dart';
import 'package:eco_collect/services/audio_services.dart';
import 'package:eco_collect/utils/kloading.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class GChat extends StatefulWidget {
  const GChat({super.key});

  @override
  State<GChat> createState() => _GChatState();
}

class _GChatState extends State<GChat> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AudioServices.playAudioAccordingToScreen(KenumScreens.gChat);
    KLoadingToast.showNotification(
      msg: KStrings.privacyMessage,
      toastType: KenumToastType.info,
      crossPage: false,
      durationInSeconds: 5,
    );
    return SafeArea(
      child: Consumer<UserDataProvider>(
        builder: (context, userProvider, child) => Stack(
          children: [
            const ReusableBgImage(
              assetImageSource: KLottie.campFireNight,
              isLottie: true,
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  // if error occured.
                  return const Center(
                    child: Text(
                      'Something went wrong, please try again later.',
                      textAlign: TextAlign.center,
                    ),
                  );
                } else if (!snapshot.hasData ||
                    snapshot.connectionState == ConnectionState.waiting) {
                  // if data not loaded yet.

                  return Center(
                    child: LottieBuilder.asset(
                      KLottie.loading,
                      height: 200.0,
                      width: 200.0,
                    ),
                  );
                }
                final messages = snapshot.data?.docs;
                List<Widget> messageWidget = [];
                for (var message in messages!) {
                  messageWidget.add(
                    MessageBubble(
                      gchatUserData: GChatUserModel.fromJson(message.data()),
                      currentUserData: userProvider.getUserData!,
                    ),
                  );
                }
                return Container(
                  margin: const EdgeInsets.only(bottom: 55.0),
                  child: MessagesBuilder(
                    children: messageWidget,
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0)
                  .copyWith(bottom: 5.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ReusableTextFormField(
                  controller: _messageController,
                  fillColor: KTheme.transparencyBlack,
                  iconColor: KTheme.fg,
                  textStyle: const TextStyle(
                    color: KTheme.lightFg,
                  ),
                  maxLines: 3,
                  textInputAction: TextInputAction.newline,
                  keyboardType: TextInputType.multiline,
                  hintText: 'Message',
                  suffixIcon: Consumer<MessageConfigProvider>(
                    builder: (context, messageConfigProvider, child) =>
                        IconButton(
                      onPressed: messageConfigProvider.canSendMessage == false
                          ? () {
                              KLoadingToast.showCustomDialog(
                                message:
                                    'Wait for ${messageConfigProvider.currentMessageTimer} seconds to send another message.',
                                toastType: KenumToastType.info,
                              );
                            }
                          : () async {
                              if (_messageController.text.trim().isNotEmpty) {
                                messageConfigProvider.sendMessage(
                                    senderText: _messageController.text.trim(),
                                    currentUser: userProvider.getUserData!);
                                _messageController.clear();
                              }
                            },
                      icon: const Icon(
                        Icons.send_rounded,
                        color: KTheme.fg,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
