import 'package:eco_collect/constants/kassets.dart';
import 'package:eco_collect/providers/solo_level_provider.dart';
import 'package:eco_collect/screens/gameplay/solo/widgets/reusable_solo_level_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';

class SoloLevelGridBuilder extends StatelessWidget {
  const SoloLevelGridBuilder({
    super.key,
    required this.soloLevelProvider,
  });
  final SoloLevelProvider soloLevelProvider;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: soloLevelProvider.levelNumbers?.length,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200.0),
      itemBuilder: (context, index) {
        final levelNumber = soloLevelProvider.levelNumbers?[index] ?? 0;
        final levelData = soloLevelProvider.getLevelTasksData(levelNumber);
        final levelsData = soloLevelProvider.getLevelsData(levelNumber);
        return levelsData == null
            ? ReusbaleSoloLevelCard(
                onTap: () {},
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Animate(
                        effects: const [
                          ScaleEffect(
                            duration: Duration(seconds: 3),
                          )
                        ],
                        child: Column(
                          children: [
                            LottieBuilder.asset(
                              KLottie.loading,
                              height: 80.0,
                              width: 80.0,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ))
            : ReusbaleSoloLevelCard(
                levelData: levelData, levelsData: levelsData);
      },
    );
  }
}
