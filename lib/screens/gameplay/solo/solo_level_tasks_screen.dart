import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confetti/confetti.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eco_collect/api/firebase_apis.dart';
import 'package:eco_collect/components/reusable_app_bar.dart';
import 'package:eco_collect/components/reusable_bg_image.dart';
import 'package:eco_collect/components/reusable_confetti.dart';
import 'package:eco_collect/components/reusable_dialog.dart';
import 'package:eco_collect/constants/kassets.dart';
import 'package:eco_collect/constants/kenums.dart';
import 'package:eco_collect/constants/ktheme.dart';
import 'package:eco_collect/models/solo_level_model.dart';
import 'package:eco_collect/models/submission_model.dart';
import 'package:eco_collect/providers/solo_level_provider.dart';
import 'package:eco_collect/providers/user_provider.dart';
import 'package:eco_collect/routes/kroutes.dart';

import 'package:eco_collect/screens/gameplay/solo/solo_level_submit_task_screen.dart';

import 'package:eco_collect/utils/common_functions.dart';
import 'package:eco_collect/utils/kloading.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

class SoloLevelTasksScreen extends StatefulWidget {
  const SoloLevelTasksScreen(
      {super.key,
      required this.levelData,
      required this.currentLevelTitle,
      required this.currentLevelDyk});
  final String currentLevelTitle;
  final String currentLevelDyk;
  final List<TaskModel> levelData;

  @override
  State<SoloLevelTasksScreen> createState() => _SoloLevelTasksScreenState();
}

class _SoloLevelTasksScreenState extends State<SoloLevelTasksScreen> {
  late ConfettiController _controllerCenter;

  @override
  void initState() {
    super.initState();
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 5));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: reusableAppBar(title: widget.currentLevelTitle),
      body: Stack(
        children: [
          ReusableBgImage(
            isLottie: true,
            assetImageSource:
                Commonfunctions.isDay() ? KLottie.day : KLottie.night,
          ),
          reusableConfetti(
            controller: _controllerCenter,
          ),
          RefreshIndicator(
            onRefresh: () async {
              await Provider.of<UserDataProvider>(context, listen: false)
                  .fetchUserTaskSubmissions();
            },
            child: ListView(
              shrinkWrap: true,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Image.asset(
                        KExplorers.explorer1,
                        height: 100,
                      ),
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1000.0),
                          color: KTheme.transparencyBlack,
                        ),
                        child: const Text(
                          'Did you know ?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: KTheme.globalAppBarBG,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: const BoxDecoration(
                    color: KTheme.transparencyBlack,
                  ),
                  child: HtmlWidget(
                    widget.currentLevelDyk,
                  ),
                ),
                const ReusableDivider(),
                Consumer<UserDataProvider>(
                  builder: (context, userprovider, child) => ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: widget.levelData.length,
                    separatorBuilder: (context, index) {
                      return const ReusableDivider();
                    },
                    itemBuilder: (context, index) {
                      final currentTask = widget.levelData[index];

                      final bool doesContainTask =
                          userprovider.getUserTaskSubmissions?.any((element) =>
                                  element.taskId ==
                                  widget.levelData[index].taskId) ??
                              false;

                      SubmissionTaskModel? submissionTask;

                      if (doesContainTask) {
                        submissionTask =
                            userprovider.getUserTaskSubmissions?.firstWhere(
                          (element) => element.taskId == currentTask.taskId,
                        );
                      }
                      return submissionTask?.status ==
                                  KenumSubmissionStatus.verified.name &&
                              submissionTask?.isClaimed == false
                          ? InkWell(
                              splashColor: KTheme.globalAppBarBG,
                              onTap: () async {
                                await _onChangeTaskTile(
                                  currentTrophies:
                                      userprovider.getUserData?.trophies,
                                  currentXp: userprovider.getUserData?.xp,
                                  status: submissionTask?.status,
                                  currentTask: currentTask,
                                  submissionTask: submissionTask,
                                );
                              },
                              child: Container(
                                height: 100.0,
                                decoration: BoxDecoration(
                                  color: _tileColor(
                                    status: submissionTask?.status,
                                    isClaimed: submissionTask?.isClaimed,
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Claim Rewards!',
                                      style: KTheme.titleStyle,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Container(
                              color: _tileColor(
                                status: submissionTask?.status,
                                isClaimed: submissionTask?.isClaimed,
                              ),
                              child: CheckboxListTile(
                                tileColor: _tileColor(
                                  status: submissionTask?.status,
                                  isClaimed: submissionTask?.isClaimed,
                                ),
                                value: submissionTask?.status ==
                                    KenumSubmissionStatus.verified.toString(),
                                title: Text(currentTask.name),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(currentTask.description),
                                    Text(
                                      'XP: ${currentTask.xp}',
                                      style: const TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'Trophies: ${currentTask.trophies}',
                                      style: const TextStyle(
                                          color: Colors.amber,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                onChanged: (value) async {
                                  await _onChangeTaskTile(
                                    currentTrophies:
                                        userprovider.getUserData?.trophies,
                                    currentXp: userprovider.getUserData?.xp,
                                    status: submissionTask?.status,
                                    currentTask: currentTask,
                                    submissionTask: submissionTask,
                                  );
                                },
                              ),
                            );
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  _submitForVerification(TaskModel currentTask) async {
    bool? result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) =>
              SoloLevelSubmitTaskScreen(task: currentTask),
        ));

    if (result == true) {
      _controllerCenter.play();
      reusableDialog(
          title: 'Hurrayyy!!',
          customTitleWidget: Column(
            children: [
              LottieBuilder.asset(
                KLottie.confetti,
                height: 120.0,
              ),
              const Text('Hurrayyy!!')
            ],
          ),
          subTitle: 'task_statuses.submittedTask.message'.tr(),
          primaryAction: () {
            Navigator.pop(context);
            _controllerCenter.stop();
          },
          primaryActionTitle:
              'task_statuses.submittedTask.primaryActionTitle'.tr());
    }
  }

  Color? _tileColor({required String? status, required bool? isClaimed}) {
    if (status == KenumSubmissionStatus.verified.name && isClaimed == false) {
      return const Color.fromARGB(161, 19, 86, 10);
    } else if (status == KenumSubmissionStatus.verified.name) {
      return KTheme.completedLevelBg;
    } else if (status == KenumSubmissionStatus.verificationFailed.name) {
      return KTheme.errorTransparent;
    } else if (status == KenumSubmissionStatus.underVerificaiton.name) {
      return KTheme.underverificationLevelBg;
    }
    return KTheme.transparencyBlack;
  }

  Future<void> _onChangeTaskTile({
    required int? currentTrophies,
    required int? currentXp,
    required String? status,
    SubmissionTaskModel? submissionTask,
    required TaskModel currentTask,
  }) async {
    if (status == KenumSubmissionStatus.verified.name) {
      if (submissionTask?.isClaimed == false) {
        await claimTaskReward(
          currentTrophies: currentTrophies ?? 0,
          currentXp: currentXp ?? 0,
          taskId: currentTask.taskId,
          rewardTrophies: currentTask.trophies,
          rewardXp: currentTask.xp,
        );
        KLoadingToast.showCharacterDialog(
          title: 'task_statuses.toClaimReward.title'.tr(),
          message: tr('task_statuses.toClaimReward.message', namedArgs: {
            'xp': currentTask.xp.toString(),
            'trophies': currentTask.trophies.toString()
          }),
          explorerImage: KExplorers.explorer8,
          barrierDismissible: false,
          canPop: false,
          hideSecondary: true,
          primaryLabel: 'task_statuses.toClaimReward.primaryLabel'.tr(),
          onPrimaryPressed: () {
            Navigator.pop(context);
          },
        );
      } else {
        KLoadingToast.showCharacterDialog(
          title: 'task_statuses.alreadyCompletedTask.title'.tr(),
          explorerImage: KExplorers.explorer5,
          message: 'task_statuses.alreadyCompletedTask.message'.tr(),
          hideSecondary: true,
          primaryLabel: 'task_statuses.alreadyCompletedTask.primaryLabel'.tr(),
          onPrimaryPressed: () {
            Navigator.pop(context);
          },
        );
      }
    } else if (status == KenumSubmissionStatus.underVerificaiton.name) {
      KLoadingToast.showCharacterDialog(
        title: 'task_statuses.underVerification.title'.tr(),
        message: 'task_statuses.underVerification.message'.tr(),
        explorerImage: KExplorers.explorer8,
        hideSecondary: true,
        primaryLabel: 'task_statuses.underVerification.primaryLabel'.tr(),
        onPrimaryPressed: () {
          Navigator.pop(context);
        },
      );
    } else if (status == KenumSubmissionStatus.verificationFailed.name) {
      KLoadingToast.showNotification(
        msg: submissionTask?.issueDetails ??
            'task_statuses.verificationFailed.message'.tr(),
        toastType: KenumToastType.error,
        durationInSeconds: 3,
      );
      _submitForVerification(currentTask);
    } else {
      _submitForVerification(currentTask);
    }
  }

  claimTaskReward({
    required String taskId,
    required int currentXp,
    required int currentTrophies,
    required int rewardXp,
    required int rewardTrophies,
  }) async {
    try {
      KLoadingToast.startLoading();

      final UserDataProvider userProvider =
          Provider.of<UserDataProvider>(context, listen: false);
      final SoloLevelProvider soloLevelProvider =
          Provider.of<SoloLevelProvider>(context, listen: false);

      final String? username = userProvider.getUserData?.username;
      //
      // update submissions
      //
      await FirebaseFirestore.instance
          .collection('submissions')
          .doc(username)
          .collection('tasks')
          .doc(taskId)
          .update({
        'isClaimed': true,
        'updatedAt': DateTime.now().toIso8601String(),
      });

      //
      // update profile
      //
      await FirebaseFirestore.instance
          .collection('users')
          .doc('endUsers')
          .collection('endUsersData')
          .doc(username)
          .update({
        'trophies': currentTrophies + rewardTrophies,
        'xp': currentXp + rewardXp,
        'updatedAt': DateTime.now().toIso8601String(),
      });

      await soloLevelProvider.fetchLevels();

      await userProvider.fetchUserTaskSubmissions();
      await FirebaseApis().fetchLatestUserData(
          context: navigatorKey.currentContext!,
          username: username ?? '',
          emailAddress: userProvider.getUserData != null
              ? userProvider.getUserData!.email
              : '');
    } catch (e) {
      KLoadingToast.showCustomDialog(
          message: 'Somthing went wrong, please try again');
    } finally {
      KLoadingToast.stopLoading();
    }
  }
}

class ReusableDivider extends StatelessWidget {
  const ReusableDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Divider(
      indent: 150.0,
      endIndent: 150.0,
    );
  }
}
