import 'package:eco_collect/api/firebase_apis.dart';
import 'package:eco_collect/components/buttons/reusable_button.dart';
import 'package:eco_collect/components/reusable_app_bar.dart';
import 'package:eco_collect/components/reusable_bg_image.dart';
import 'package:eco_collect/components/reusable_textformfield.dart';
import 'package:eco_collect/components/reusable_top_character_dialogue.dart';
import 'package:eco_collect/constants/error_handler_values.dart';
import 'package:eco_collect/constants/kassets.dart';
import 'package:eco_collect/constants/kenums.dart';
import 'package:eco_collect/constants/kshowcase_keys.dart';
import 'package:eco_collect/constants/kstrings.dart';
import 'package:eco_collect/constants/ktheme.dart';
import 'package:eco_collect/models/solo_level_model.dart';
import 'package:eco_collect/models/submission_model.dart';
import 'package:eco_collect/routes/kroutes.dart';
import 'package:eco_collect/services/connectivity_services.dart';
import 'package:eco_collect/services/showcase_services.dart';
import 'package:eco_collect/utils/common_functions.dart';
import 'package:eco_collect/utils/kloading.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

class SoloLevelSubmitTaskScreen extends StatefulWidget {
  const SoloLevelSubmitTaskScreen({super.key, required this.task});
  final TaskModel task;

  @override
  State<SoloLevelSubmitTaskScreen> createState() =>
      _SoloLevelSubmitTaskScreenState();
}

class _SoloLevelSubmitTaskScreenState extends State<SoloLevelSubmitTaskScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController youtubeLinkController = TextEditingController();
  final TextEditingController messageToWorldController =
      TextEditingController();

  bool isPublic = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: reusableAppBar(title: 'Submit ${widget.task.name}'),
      body: ShowCaseWidget(
        builder: Builder(builder: (context) {
          ShowcaseServices().startShowCase(
              context: context, screen: KenumScreens.submitVideoScreen);
          return Stack(
            children: [
              ReusableBgImage(
                isLottie: true,
                assetImageSource:
                    Commonfunctions.isDay() ? KLottie.day : KLottie.night,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  onChanged: () => _formKey.currentState!.validate(),
                  child: ListView(shrinkWrap: true, children: [
                    const ReusableTopCharacterDialogue(
                      message:
                          "Ready to become a sustainability hero? Share your completed task with the world! Simply paste the YouTube link of your accomplishment here. Once our team verifies it, your video will be proudly showcased on the Heroes tab, inspiring others to join our mission. Plus, claim your well-deserved rewards after verification. Your actions speak volumes – let's make waves together!",
                      explorerImagePath: KExplorers.explorer5,
                    ),
                    _gap(),
                    Showcase(
                      key: KShowcaseKeys.youtubeLinkField,
                      title: KShowcaseData.youtubeLinkTextField.title,
                      description:
                          KShowcaseData.youtubeLinkTextField.description,
                      child: ReusableTextFormField(
                        controller: youtubeLinkController,
                        label: 'Youtube link',
                        hintText: 'https://www.youtube.com/watch?v=80biIVdUkzM',
                        addUrlValidation: true,
                      ),
                    ),
                    _gap(),
                    Showcase(
                      key: KShowcaseKeys.messageField,
                      title: KShowcaseData.messageToWorldTextField.title,
                      description:
                          KShowcaseData.messageToWorldTextField.description,
                      child: ReusableTextFormField(
                        controller: messageToWorldController,
                        label: 'Message To World',
                        hintText:
                            'I really enjoyed this task, i would recommend people to try it!!',
                        minLines: 4,
                        maxLines: 4,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        validator: (_) {
                          return null;
                        },
                      ),
                    ),
                    _gap(),
                    Showcase(
                      key: KShowcaseKeys.beAHeroCheck,
                      title: KShowcaseData.beAHeroCheck.title,
                      description: KShowcaseData.beAHeroCheck.description,
                      child: Container(
                        decoration: BoxDecoration(
                          color: KTheme.transparencyBlack,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: CheckboxListTile(
                          value: isPublic,
                          onChanged: (value) {
                            setState(() {
                              isPublic = value!;
                            });
                          },
                          title: const Text('Be a HERO'),
                          subtitle:
                              Text(KShowcaseData.beAHeroCheck.description),
                        ),
                      ),
                    ),
                    _gap(),
                    Commonfunctions.gapMultiplier(gapMultiplier: 4),
                  ]),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Showcase(
                      tooltipPosition: TooltipPosition.top,
                      key: KShowcaseKeys.submitTaskButton,
                      title: KShowcaseData.submitTaskButton.title,
                      description: KShowcaseData.submitTaskButton.description,
                      child: ReusableButton(
                        label: 'Submit for verification',
                        icon: Icons.verified,
                        onTap: () async {
                          final hasInternet = await ConnectivityServices()
                              .checkInternetConnectivity();
                          if (!hasInternet) {
                            KLoadingToast.showCharacterDialog(
                              title: 'No Internet',
                              message: ErrorsHandlerValues.noInternet,
                              explorerImage: KExplorers.explorer5,
                              hideSecondary: true,
                              primaryLabel: "Retry",
                              onPrimaryPressed: () {
                                Navigator.pop(context);
                              },
                            );
                          } else if (_formKey.currentState!.validate()) {
                            KLoadingToast.showCharacterDialog(
                                title: "Confirm Submission",
                                message:
                                    "Are you sure you want to submit your completed task? Your contribution will help us in our mission to create a cleaner and greener world. Once submitted, your task will be reviewed for verification. Let's make a positive impact together!",
                                primaryLabel: "Submit Task",
                                secondaryLabel: "Cancel",
                                onPrimaryPressed: () async {
                                  try {
                                    await _submit();

                                    Navigator.pop(navigatorKey.currentContext!);
                                    Navigator.pop(
                                        navigatorKey.currentContext!, true);
                                  } catch (e) {
                                    // error
                                  }
                                },
                                onSecondaryPressed: () {
                                  Navigator.pop(context);
                                });
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }

  SizedBox _gap() {
    return const SizedBox(
      height: 8.0,
    );
  }

  @override
  void dispose() {
    youtubeLinkController.dispose();
    messageToWorldController.dispose();
    super.dispose();
  }

  _submit() async {
    try {
      await FirebaseApis().submitTask(
        task: widget.task,
        submissionTaskDetails: SubmissionTaskModel(
          taskId: widget.task.taskId,
          taskTitle: widget.task.name,
          videoUrl: youtubeLinkController.text.trim(),
          isPublic: isPublic,
          status: KenumSubmissionStatus.underVerificaiton.name,
          isClaimed: false,
          createdAt: DateTime.now().toIso8601String(),
          collab: [],
          message: messageToWorldController.text.trim().isEmpty
              ? ""
              : messageToWorldController.text.trim(),
        ),
      );
    } catch (e) {
      KLoadingToast.showCustomDialog(
        message: 'Something went wrong, please try again later.',
        toastType: KenumToastType.error,
      );
    }
  }
}
