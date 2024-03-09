import 'package:eco_collect/constants/ktheme.dart';
import 'package:eco_collect/models/solo_level_model.dart';
import 'package:eco_collect/routes/kroutes.dart';
import 'package:eco_collect/screens/gameplay/solo/solo_level_tasks_screen.dart';
import 'package:flutter/material.dart';

class ReusbaleSoloLevelCard extends StatelessWidget {
  const ReusbaleSoloLevelCard({
    super.key,
    this.levelData,
    this.levelsData,
    this.onTap,
    this.child,
  });

  final List<TaskModel>? levelData;
  final SoloLevelModel? levelsData;
  final Function()? onTap;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: KTheme.splashColor,
        borderRadius: BorderRadius.circular(10.0),
        onTap: onTap ??
            () {
              levelData != null
                  ? KRoute.push(
                      context: context,
                      page: SoloLevelTasksScreen(
                        levelData: levelData!,
                        currentLevelDyk: levelsData!.dyk,
                        currentLevelTitle: levelsData!.levelTitle,
                      ))
                  : null;
            },
        child: Container(
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: KTheme.transparencyBlack,
          ),
          child: child ??
              Image.asset('assets/icons/sdg/${levelsData!.levelNumber}.png'),
        ),
      ),
    );
  }
}
