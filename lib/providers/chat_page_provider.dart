import 'dart:async';

import 'package:do_chat/model/chat_message.dart';
import 'package:do_chat/providers/auth_provider.dart';
import 'package:do_chat/services/cloudinary_service.dart';
import 'package:do_chat/services/database_service.dart';
import 'package:do_chat/services/media_service.dart';
import 'package:do_chat/services/navigation_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ChatPageProvider extends ChangeNotifier {
  late DatabaseService _db;
  late CloudinaryStorageService _cloudinary;
  late MediaService _mediaService;
  late NavigationService _navigation;

  AuthProvider _auth;
  ScrollController _messageListViewController;

  String _chatId;
  List<ChatMessage>? messages;

  late StreamSubscription _messageStream;

  String? _message;

  String get message {
    return _message ?? "";
  }

  ChatPageProvider(this._auth, this._chatId, this._messageListViewController) {
    _db = GetIt.instance.get<DatabaseService>();
    _cloudinary = GetIt.instance.get<CloudinaryStorageService>();
    _mediaService = GetIt.instance.get<MediaService>();
    _navigation = GetIt.instance.get<NavigationService>();
    listenToMessage();
  }

  @override
  void dispose() {
    _messageStream.cancel();
    super.dispose();
  }

  void listenToMessage() {
    try {
      _messageStream = _db.streamMessageForChat(_chatId).listen((snapshot) {
        List<ChatMessage> _messages =
            snapshot.docs.map((_m) {
              Map<String, dynamic> _messageData =
                  _m.data() as Map<String, dynamic>;
              return ChatMessage.fromJson(_messageData);
            }).toList();
        messages = _messages;
        notifyListeners();
        // add scroll to bottom call
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error listening to messages: $e");
      }
    }
  }

  void sendTextMessage() {
    if (_message != null) {
      ChatMessage _messageToSend = ChatMessage(
        senderId: _auth.user.uId,
        content: _message!,
        type: MessageType.text,
        sentTime: DateTime.now(),
      );
      _db.addMessageToChat(_chatId, _messageToSend);
    }
  }

  void sendImageMessage() async {
    try {
      PlatformFile? _file = await _mediaService.pickImageFromLibrary();
      if (_file != null) {
        String? _downloadURL = await _cloudinary.saveChatFileToCloudinary(
          _chatId,
          _auth.user.uId,
          _file,
        );
        ChatMessage _messageToSend = ChatMessage(
          senderId: _auth.user.uId,
          content: _downloadURL!,
          type: MessageType.image,
          sentTime: DateTime.now(),
        );
        _db.addMessageToChat(_chatId, _messageToSend);
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error sending image message: $e");
      }
    }
  }

  void deleteChat() {
    goBack();
    _db.deleteChat(_chatId);
  }

  void goBack() {
    _navigation.goBack();
  }
}
