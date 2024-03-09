import 'package:eco_collect/components/buttons/reusable_current_tier_button.dart';
import 'package:eco_collect/components/reusable_textformfield.dart';
import 'package:eco_collect/constants/ktheme.dart';
import 'package:eco_collect/models/user_data_model.dart';
import 'package:eco_collect/utils/common_functions.dart';
import 'package:flutter/material.dart';

class UserDetails extends StatelessWidget {
  const UserDetails({super.key, required this.userDetails});
  final UserDataModel userDetails;

  @override
  Widget build(BuildContext context) {
    Color bg = KTheme.transparencyBlack;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          ReusableTextFormField(
            initialValue: userDetails.fullName,
            label: 'Name',
            readOnly: true,
            fillColor: bg,
            prefixIcon: const Icon(Icons.person),
          ),
          Commonfunctions.gapMultiplier(),
          ReusableTextFormField(
            initialValue: userDetails.username,
            label: 'username',
            readOnly: true,
            fillColor: bg,
            prefixIcon: const Icon(Icons.alternate_email_rounded),
          ),
          Commonfunctions.gapMultiplier(),
          ReusableTextFormField(
            initialValue: userDetails.email,
            label: 'email',
            readOnly: true,
            fillColor: bg,
            prefixIcon: const Icon(Icons.email_outlined),
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
            suffixIcon: const ReusableTierImageButton(
              height: 20.0,
              width: 20.0,
            ),
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
