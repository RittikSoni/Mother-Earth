class DummySoloLevelModel {
  int level;

  String? levelTitle;
  List<SoloLevelTasksModel> tasks;

  DummySoloLevelModel(
      {required this.level, required this.tasks, this.levelTitle});
}

class SoloLevelTasksModel {
  String task;
  bool? isCompleted; // Default `false`
  bool? isSubmittedForVerification; // Default `false`
  String? issueDetails; // Default null/empty/nokey

  SoloLevelTasksModel({
    required this.task,
    this.isCompleted,
    this.isSubmittedForVerification,
    this.issueDetails,
  });
}
