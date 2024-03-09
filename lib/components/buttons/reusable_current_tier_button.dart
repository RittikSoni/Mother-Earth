import 'package:eco_collect/providers/level_provider.dart';
import 'package:eco_collect/providers/user_provider.dart';
import 'package:eco_collect/routes/kroutes.dart';
import 'package:eco_collect/screens/badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReusableTierImageButton extends StatelessWidget {
  const ReusableTierImageButton({
    super.key,
    this.width,
    this.height,
    this.trophies,
  });
  final double? width;
  final double? height;
  final int? trophies;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        KRoute.push(context: context, page: const Badges());
      },
      child: Image.asset(
        Provider.of<LevelProvider>(context, listen: false)
            .getPlayerCurrentHeroLevelData(
                currentTrophies: trophies ??
                    Provider.of<UserDataProvider>(context, listen: false)
                        .getUserData
                        ?.trophies)
            .image,
        height: height,
        width: width,
      ),
    );
  }
}
