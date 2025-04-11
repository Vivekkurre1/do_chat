import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageType { text, image, unknown }

class ChatMessage {
  final String senderId;
  final MessageType type;
  final String content;
  final DateTime sentTime;

  ChatMessage({
    required this.senderId,
    required this.type,
    required this.content,
    required this.sentTime,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    MessageType _messageType;
    switch (json["type"]) {
      case "text":
        _messageType = MessageType.text;
        break;
      case "image":
        _messageType = MessageType.image;
        break;
      default:
        _messageType = MessageType.unknown;
        break;
    }
    return ChatMessage(
      senderId: json["sender_id"],
      type: _messageType,
      content: json["content"],
      sentTime: json["sent_time"].toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    String _messageType;
    switch (type) {
      case MessageType.text:
        _messageType = "text";
        break;
      case MessageType.image:
        _messageType = "image";
        break;
      default:
        _messageType = "unknown";
        break;
    }
    return {
      "sender_id": senderId,
      "type": _messageType,
      "content": content,
      "sent_time": Timestamp.fromDate(sentTime),
    };
  }
}
