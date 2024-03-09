class SoloLevelModel {
  final int levelNumber;
  final String levelTitle;
  final String dyk;
  final List<TaskModel> tasks;

  SoloLevelModel({
    required this.levelNumber,
    required this.tasks,
    required this.dyk,
    required this.levelTitle,
  });

  factory SoloLevelModel.fromJson(Map<String, dynamic> json) {
    final List<TaskModel> tasks = (json['tasks'] as Map<String, dynamic>)
        .entries
        .map((entry) => TaskModel.fromJson(entry.value as Map<String, dynamic>))
        .toList();

    return SoloLevelModel(
      levelNumber: json['levelNumber'],
      tasks: tasks,
      dyk: json['dyk'],
      levelTitle: json['levelTitle'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dyk': dyk,
      'levelTitle': levelTitle,
      'levelumber': levelNumber,
      'tasks': tasks.map((task) => task.toJson()).toList(),
    };
  }
}

class TaskModel {
  final String taskId;
  final String name;
  final String description;
  final int xp;
  final int trophies;

  TaskModel({
    required this.taskId,
    required this.name,
    required this.description,
    required this.xp,
    required this.trophies,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      taskId: json['taskId'],
      name: json['name'],
      description: json['description'],
      xp: json['xp'],
      trophies: json['trophies'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'taskId': taskId,
      'name': name,
      'description': description,
      'xp': xp,
      'trophies': trophies,
    };
  }
}
