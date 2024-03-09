class SubmissionModel {
  final List<SubmissionTaskModel> tasks;
  final String username;
  final String name;

  SubmissionModel(
      {required this.tasks, required this.username, required this.name});

  factory SubmissionModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> tasksData = json['tasks'] ?? [];
    final List<SubmissionTaskModel> tasks = tasksData
        .map((taskData) => SubmissionTaskModel.fromJson(taskData))
        .toList();
    return SubmissionModel(
      tasks: tasks,
      name: json['name'],
      username: json['username'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'username': username,
      'tasks': tasks.map((task) => task.toJson()).toList(),
    };
  }
}

class SubmissionTaskModel {
  final String taskId;
  final String taskTitle;
  final String videoUrl;
  final String? message;
  final String? issueDetails;
  final bool isPublic;
  final String status;
  final bool isClaimed;
  final List<String>? collab;
  final String createdAt;

  SubmissionTaskModel({
    required this.taskId,
    required this.taskTitle,
    required this.videoUrl,
    required this.isPublic,
    required this.status,
    required this.isClaimed,
    this.message,
    this.collab,
    this.issueDetails,
    required this.createdAt,
  });

  factory SubmissionTaskModel.fromJson(Map<String, dynamic> json) {
    return SubmissionTaskModel(
      taskId: json['taskId'],
      taskTitle: json['taskTitle'],
      videoUrl: json['videoUrl'],
      message: json['message'],
      issueDetails: json['issueDetails'],
      isPublic: json['isPublic'],
      status: json['status'],
      isClaimed: json['isClaimed'],
      collab: List<String>.from(json['collab']),
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'taskId': taskId,
      'taskTitle': taskTitle,
      'videoUrl': videoUrl,
      'issueDetails': issueDetails,
      'message': message,
      'isPublic': isPublic,
      'status': status,
      'isClaimed': isClaimed,
      'collab': collab,
      'createdAt': createdAt,
    };
  }
}
