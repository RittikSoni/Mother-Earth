class GChatUserModel {
  String senderText;
  String senderEmail;
  String senderName;
  String senderUsername;
  String country;
  int trophies;
  int xp;

  GChatUserModel({
    required this.senderText,
    required this.senderEmail,
    required this.senderName,
    required this.senderUsername,
    required this.country,
    required this.trophies,
    required this.xp,
  });

  factory GChatUserModel.fromJson(Map<String, dynamic> json) {
    return GChatUserModel(
      senderText: json['senderText'],
      senderEmail: json['senderEmail'],
      senderName: json['senderName'],
      senderUsername: json['senderUsername'],
      country: json['country'],
      trophies: json['trophies'],
      xp: json['xp'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['senderText'] = senderText;
    data['senderEmail'] = senderEmail;
    data['senderName'] = senderName;
    data['senderUsername'] = senderUsername;
    data['country'] = country;
    data['trophies'] = trophies;
    data['xp'] = xp;
    return data;
  }
}
