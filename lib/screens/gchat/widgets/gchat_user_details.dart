import 'package:eco_collect/components/reusable_textformfield.dart';
import 'package:eco_collect/constants/ktheme.dart';
import 'package:eco_collect/models/g_chat_user_model.dart';
import 'package:eco_collect/utils/common_functions.dart';
import 'package:flutter/material.dart';

class GChatUserDetails extends StatelessWidget {
  const GChatUserDetails({super.key, required this.userDetails});
  final GChatUserModel userDetails;

  @override
  Widget build(BuildContext context) {
    Color bg = KTheme.transparencyBlack;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          ReusableTextFormField(
            initialValue: userDetails.senderName,
            label: 'Name',
            readOnly: true,
            fillColor: bg,
            prefixIcon: const Icon(Icons.person),
          ),
          Commonfunctions.gapMultiplier(),
          ReusableTextFormField(
            initialValue: userDetails.senderUsername,
            label: 'username',
            readOnly: true,
            fillColor: bg,
            prefixIcon: const Icon(Icons.alternate_email_rounded),
          ),
          Commonfunctions.gapMultiplier(),
          ReusableTextFormField(
            initialValue: userDetails.country,
            label: 'country',
            readOnly: true,
            fillColor: bg,
            prefixIcon: const Icon(Icons.location_on_outlined),
          ),
          Commonfunctions.gapMultiplier(),
          ReusableTextFormField(
            initialValue: userDetails.trophies.toString(),
            label: 'trophies'.toString(),
            readOnly: true,
            fillColor: bg,
            prefixIcon: const Icon(Icons.wine_bar_outlined),
          ),
          Commonfunctions.gapMultiplier(),
          ReusableTextFormField(
            initialValue: userDetails.xp.toString(),
            label: 'xp'.toString(),
            readOnly: true,
            fillColor: bg,
            prefixIcon: const Icon(Icons.one_x_mobiledata_sharp),
          ),
        ],
      ),
    );
  }
}
