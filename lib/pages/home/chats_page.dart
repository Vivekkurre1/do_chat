import 'package:do_chat/model/chat.dart';
import 'package:do_chat/model/chat_message.dart';
import 'package:do_chat/model/chat_user.dart';
import 'package:do_chat/providers/auth_provider.dart';
import 'package:do_chat/providers/chat_provider.dart';
import 'package:do_chat/widgets/custom_list_view.dart';
import 'package:do_chat/widgets/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  late double _deviceHeight;
  late double _deviceWidth;

  late AuthProvider _authProvider;
  late ChatsProvider _chatProvider;
  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _authProvider = Provider.of<AuthProvider>(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChatsProvider>(
          create: (_) => ChatsProvider(_authProvider),
        ),
      ],
      child: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Builder(
      builder: (BuildContext context) {
        _chatProvider = context.watch<ChatsProvider>();
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: _deviceWidth * 0.03,
            vertical: _deviceHeight * 0.02,
          ),
          height: _deviceHeight * 0.98,
          width: _deviceWidth * 0.97,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TopBar(
                "Chats",
                primaryAction: IconButton(
                  onPressed: () {
                    _authProvider.logout();
                  },
                  icon: Icon(Icons.logout_outlined),
                  color: Colors.white,
                ),
              ),
              _chatList(),
            ],
          ),
        );
      },
    );
  }

  Widget _chatList() {
    List<Chat>? chats = _chatProvider.chats;
    return Expanded(
      child: (() {
        if (chats != null) {
          if (chats.isNotEmpty) {
            return ListView.builder(
              itemCount: chats.length,
              itemBuilder: (BuildContext context, index) {
                return _chatTile(chats[index]);
              },
            );
          } else {
            return Center(
              child: Text("No Chats", style: TextStyle(color: Colors.white)),
            );
          }
        } else {
          return Center(child: CircularProgressIndicator(color: Colors.white));
        }
      }()),
    );
  }

  Widget _chatTile(Chat chat) {
    List<ChatUser> recepients = chat.recepients;
    bool isActive = recepients.any((user) => user.wasRecentlyActive());
    String subTitleText = "";
    if (chat.messages.isNotEmpty) {
      subTitleText =
          chat.messages.first.type != MessageType.text
              ? "Media attchment"
              : chat.messages.first.content;
    }
    return CustomListViewTileWithActivity(
      height: _deviceHeight * .10,
      title: chat.chatTitle(),
      subtitle: subTitleText,
      imageUrl: chat.imageURL(),
      isActive: isActive,
      isActivity: chat.activity,
      onTap: () {},
    );
  }
}
