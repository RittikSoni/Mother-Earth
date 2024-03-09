import 'package:eco_collect/services/dummy_models/dummy_models.dart';

List<DummySoloLevelModel> dummySoloLevelData = [
  DummySoloLevelModel(
    level: 1,
    tasks: [
      SoloLevelTasksModel(isCompleted: true, task: 'Plant a tree'),
    ],
  ),
  DummySoloLevelModel(
    level: 2,
    tasks: [
      SoloLevelTasksModel(
        isCompleted: false,
        task: 'Play a outdoor game.',
      ),
      SoloLevelTasksModel(
        isCompleted: true,
        task: 'Help your lovedones once',
      ),
      SoloLevelTasksModel(
        isCompleted: false,
        task: 'Clean your room',
        isSubmittedForVerification: true,
      ),
      SoloLevelTasksModel(
          isCompleted: false,
          task: 'Help mom/dad/siblings',
          issueDetails:
              'No video found, please try to submit it again with correct details'),
    ],
  ),
  DummySoloLevelModel(
    level: 3,
    tasks: [
      SoloLevelTasksModel(
        isCompleted: false,
        task: 'Help a beggar or someone who needs.',
      ),
      SoloLevelTasksModel(isCompleted: false, task: 'Study for an hour.'),
      SoloLevelTasksModel(
          isCompleted: false, task: 'Do yoga for atleast 10 minutes.'),
      SoloLevelTasksModel(
          isCompleted: false, task: 'Do sirashan yoga for atleast 5 minutes.'),
    ],
  ),
];
