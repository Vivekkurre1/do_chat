class ChatUser {
  final String uId;
  final String name;
  final String email;
  final String imageUrl;
  late DateTime lastActive;

  ChatUser({
    required this.uId,
    required this.name,
    required this.email,
    required this.imageUrl,
    required this.lastActive,
  });

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
      uId: json['uid'],
      name: json['name'],
      email: json['email'],
      imageUrl: json['imageUrl'],
      lastActive: json['lastActive'].toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uId,
      'name': name,
      'email': email,
      'imageUrl': imageUrl,
      'lastActive': lastActive,
    };
  }

  String lastDayActive() {
    return "${lastActive.day}/${lastActive.month}/${lastActive.year}";
  }

  bool wasRecentlyActive() {
    return DateTime.now().difference(lastActive).inHours < 2;
  }
}
