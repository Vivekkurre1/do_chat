import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_chat/model/chat.dart';
import 'package:do_chat/model/chat_user.dart';
import 'package:do_chat/pages/chat/chat_page.dart';
import 'package:do_chat/providers/auth_provider.dart';
import 'package:do_chat/services/database_service.dart';
import 'package:do_chat/services/navigation_service.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

class UsersPageProvider extends ChangeNotifier {
  AuthProvider _auth;

  late DatabaseService _db;
  late NavigationService _navigation;

  List<ChatUser>? users;
  late List<ChatUser> _selectedUsers;

  List<ChatUser> get selectedUsers {
    return _selectedUsers;
  }

  UsersPageProvider(this._auth) {
    _selectedUsers = [];
    _db = GetIt.instance.get<DatabaseService>();
    _navigation = GetIt.instance.get<NavigationService>();
    getUsers();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getUsers({String? name}) async {
    _selectedUsers = [];

    try {
      _db.getUsers(name: name).then((snapshot) {
        users =
            snapshot.docs.map((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              data["uid"] = doc.id;
              return ChatUser.fromJson(data);
            }).toList();
        notifyListeners();
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void updateSearchedUsers(ChatUser user) {
    if (_selectedUsers.contains(user)) {
      _selectedUsers.remove(user);
    } else {
      _selectedUsers.add(user);
    }
    notifyListeners();
  }

  void createChat() async {
    try {
      List<String> _membersIds =
          _selectedUsers.map((_user) => _user.uId).toList();
      _membersIds.add(_auth.user.uId);
      bool _isGroup = _selectedUsers.length > 1;
      DocumentReference? _doc = await _db.createChat({
        "is_group": _isGroup,
        "is_activity": false,
        "members": _membersIds,
      });

      List<ChatUser> _members = [];
      for (var uid in _membersIds) {
        DocumentSnapshot _userSnapshot = await _db.getUser(uid);
        Map<String, dynamic> _userData =
            _userSnapshot.data() as Map<String, dynamic>;
        _userData["uid"] = _userSnapshot.id;
        _members.add(ChatUser.fromJson(_userData));
      }
      ChatPage _chatPage = ChatPage(
        chat: Chat(
          uid: _doc!.id,
          currentUserId: _auth.user.uId,
          members: _members,
          messages: [],
          group: _isGroup,
          activity: false,
        ),
      );
      _selectedUsers = [];
      notifyListeners();
      _navigation.navigateToPage(_chatPage);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
