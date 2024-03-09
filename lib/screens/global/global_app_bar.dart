import 'package:eco_collect/components/buttons/reusable_current_tier_button.dart';
import 'package:eco_collect/constants/kenums.dart';
import 'package:eco_collect/constants/kshowcase_keys.dart';
import 'package:eco_collect/constants/kstrings.dart';
import 'package:eco_collect/constants/ktheme.dart';
import 'package:eco_collect/models/user_data_model.dart';
import 'package:eco_collect/providers/level_provider.dart';
import 'package:eco_collect/providers/user_provider.dart';

import 'package:eco_collect/routes/kroutes.dart';
import 'package:eco_collect/screens/profile/profile.dart';
import 'package:eco_collect/screens/profile/widgets/user_avatar.dart';
import 'package:eco_collect/services/showcase_services.dart';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

PreferredSize globalAppBar(BuildContext context) {
  ShowcaseServices().startShowCase(context: context, screen: KenumScreens.home);
  return PreferredSize(
    preferredSize: const Size.fromHeight(60.0),
    child: Consumer2<UserDataProvider, LevelProvider>(
      builder: (ctx, userProvider, levelProvider, child) => AppBar(
        backgroundColor: KTheme.globalAppBarBG,
        leading:
            // PLAYER CURRENT TIER
            Showcase(
                key: KShowcaseKeys.badge,
                title: KShowcaseData.appBarBadge.title,
                description: KShowcaseData.appBarBadge.description,
                child: const ReusableTierImageButton()),
        title: Text('Hi! ${userProvider.getUserData?.fullName}'),
        actions: [
          // User Card collection
          Showcase(
            key: KShowcaseKeys.profile,
            title: KShowcaseData.appBarProfile.title,
            description: KShowcaseData.appBarProfile.description,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Hero(
                tag: 'heroProfile',
                child: InkWell(
                  onTap: () {
                    KRoute.pushFadeAnimation(
                      context: context,
                      durationMilliseconds: 1500,
                      page: const Profile(),
                    );
                  },
                  child: UserAvatar(
                    userData: userProvider.getUserData ??
                        UserDataModel(
                            fullName: 'Loading',
                            username: 'Loading',
                            xp: 0,
                            trophies: 0,
                            email: 'Loading',
                            country: 'Loading',
                            isBanned: false,
                            banReason: '',
                            createdAt: DateTime.now(),
                            updatedAt: DateTime.now()),
                    levelProvider: levelProvider,
                    avatarRadius: 20.0,
                    isBadgeVisible: false,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
