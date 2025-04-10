import 'package:do_chat/model/chat_message.dart';
import 'package:do_chat/model/chat_user.dart';

class Chat {
  final String uid;
  final String currentUserId;
  final bool activity;
  final bool group;
  final List<ChatUser> members;
  List<ChatMessage> messages;
  late final List<ChatUser> recepients;

  Chat({
    required this.uid,
    required this.currentUserId,
    required this.activity,
    required this.group,
    required this.members,
    required this.messages,
  }) {
    recepients = members.where((i) => i.uId != currentUserId).toList();
  }

  List<ChatUser> getRecepients() {
    return recepients;
  }

  String getRecepientName() {
    return !group
        ? recepients[0].name
        : recepients.map((user) => user.name).join(", ");
  }

  String imageURL() {
    return !group
        ? recepients[0].imageUrl
        : "https://res.cloudinary.com/dnjeaojih/image/upload/v1744290873/group_image_zwjsyr.avif";
  }
}
