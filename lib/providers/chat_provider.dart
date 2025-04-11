import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_chat/model/chat.dart';
import 'package:do_chat/model/chat_message.dart';
import 'package:do_chat/model/chat_user.dart';
import 'package:do_chat/providers/auth_provider.dart';
import 'package:do_chat/services/database_service.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

class ChatsProvider extends ChangeNotifier {
  AuthProvider _authProvider;
  late DatabaseService _databaseService;

  List<Chat>? chats;

  late StreamSubscription _chatsStream;

  ChatsProvider(this._authProvider) {
    _databaseService = GetIt.instance.get<DatabaseService>();

    getChats();
  }

  //autoDispose
  @override
  void dispose() {
    _chatsStream.cancel();
    super.dispose();
  }

  void getChats() async {
    try {
      _chatsStream = _databaseService
          .getChatsForUser(_authProvider.user.uId)
          .listen((snapshot) async {
            chats = await Future.wait(
              snapshot.docs.map((d) async {
                Map<String, dynamic> chatData =
                    d.data() as Map<String, dynamic>;
                //get users in chat
                List<ChatUser> members = [];
                for (var uid in chatData["members"]) {
                  DocumentSnapshot userSnapshot = await _databaseService
                      .getUser(uid);
                  Map<String, dynamic> userData =
                      userSnapshot.data() as Map<String, dynamic>;
                  userData["uid"] = userSnapshot.id;
                  members.add(ChatUser.fromJson(userData));
                }
                //get last message for chat
                List<ChatMessage> messages = [];
                QuerySnapshot chatMessage = await _databaseService
                    .getLastMessageForChat(d.id);
                if (chatMessage.docs.isNotEmpty) {
                  Map<String, dynamic> messageData =
                      chatMessage.docs.first.data()! as Map<String, dynamic>;

                  ChatMessage message = ChatMessage.fromJson(messageData);
                  messages.add(message);
                }

                //return chat instance
                return Chat(
                  uid: d.id,
                  currentUserId: _authProvider!.user.uId,
                  activity: chatData["is_activity"],
                  group: chatData["is_group"],
                  members: members,
                  messages: messages,
                );
              }).toList(),
            );
            notifyListeners();
          });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
