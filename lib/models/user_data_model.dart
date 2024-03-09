class UserDataModel {
  UserDataModel({
    required this.fullName,
    required this.username,
    required this.xp,
    required this.trophies,
    required this.email,
    required this.country,
    required this.isBanned,
    required this.banReason,
    required this.createdAt,
    required this.updatedAt,
  });

  String fullName;
  String username;
  String email;
  int xp;
  int trophies;
  String country;
  bool isBanned;
  String banReason;
  DateTime createdAt;
  DateTime updatedAt;

  factory UserDataModel.fromJson(Map<String, dynamic> json) {
    return UserDataModel(
      fullName: json['fullName'],
      username: json['username'],
      email: json['email'],
      country: json['country'],
      isBanned: json['isBanned'],
      banReason: json['banReason'],
      xp: json['xp'],
      trophies: json['trophies'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'fullName': fullName,
      'username': username,
      'email': email,
      'country': country,
      'xp': xp,
      'trophies': trophies,
      'isBanned': isBanned,
      'banReason': banReason,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
