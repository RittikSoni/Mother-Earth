import 'package:eco_collect/constants/kdimens.dart';
import 'package:eco_collect/constants/ktheme.dart';
import 'package:eco_collect/models/g_chat_user_model.dart';
import 'package:eco_collect/models/user_data_model.dart';
import 'package:eco_collect/routes/kroutes.dart';
import 'package:eco_collect/screens/gchat/widgets/g_chat_user_profile.dart';
import 'package:eco_collect/screens/profile/profile.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.currentUserData,
    required this.gchatUserData,
  });

  final GChatUserModel gchatUserData;
  final UserDataModel currentUserData;

  @override
  Widget build(BuildContext context) {
    final String senderEmail = gchatUserData.senderEmail;
    final String senderName = gchatUserData.senderName;
    final String messageText = gchatUserData.senderText;

    bool isMe = currentUserData.email == senderEmail;
    return Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            isMe ? Container() : _circleAvatar(isMe),
            Text(
              senderName,
            ),
            !isMe ? Container() : _circleAvatar(isMe),
          ],
        ),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: KDimens.screenWidth / 1.5),
          child: Container(
            padding: _getPadding(),
            margin: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              color: _getColor(isMe),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Text(messageText),
          ),
        ),
      ],
    );
  }

  Padding _circleAvatar(bool isMe) {
    return Padding(
      padding: _getPadding(),
      child: InkWell(
        onTap: () {
          KRoute.push(
              context: navigatorKey.currentContext!,
              page: isMe
                  ? const Profile()
                  : GChatUserProfile(
                      gChatUserData: gchatUserData,
                    ));
        },
        child: CircleAvatar(
          backgroundColor: _getColor(isMe),
          radius: 10.0,
          child: Text(
            gchatUserData.senderName.substring(0, 2).toUpperCase(),
            style: const TextStyle(
              fontSize: 10.0,
            ),
          ),
        ),
      ),
    );
  }

  Color _getColor(bool isMe) {
    return isMe ? KTheme.myMessageBG : KTheme.otherMessageBG;
  }

  EdgeInsets _getPadding() {
    return const EdgeInsets.all(8.0);
  }
}
