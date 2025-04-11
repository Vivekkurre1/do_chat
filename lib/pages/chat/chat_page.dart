import 'package:do_chat/model/chat.dart';
import 'package:do_chat/model/chat_message.dart';
import 'package:do_chat/providers/auth_provider.dart';
import 'package:do_chat/providers/chat_page_provider.dart';
import 'package:do_chat/services/navigation_service.dart';
import 'package:do_chat/widgets/custom_list_view.dart';
import 'package:do_chat/widgets/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  final Chat chat;
  const ChatPage({super.key, required this.chat});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late double _deviceHeight;
  late double _deviceWidth;

  late AuthProvider _auth;
  late ChatPageProvider _chatPageProvider;

  late GlobalKey<FormState> _messageFormState;
  late ScrollController _messageListViewController;
  late NavigationService _navigation;

  @override
  void initState() {
    super.initState();
    _messageFormState = GlobalKey<FormState>();
    _messageListViewController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthProvider>(context);
    _navigation = GetIt.instance<NavigationService>();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChatPageProvider>(
          create:
              (_) => ChatPageProvider(
                _auth,
                widget.chat.uid,
                _messageListViewController,
              ),
        ),
      ],
      child: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Builder(
      builder: (BuildContext context) {
        _chatPageProvider = context.watch<ChatPageProvider>();
        return Scaffold(
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: _deviceWidth * 0.03,
                vertical: _deviceHeight * 0.02,
              ),
              height: _deviceHeight * 0.98,
              width: _deviceWidth * 0.97,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [_topBar(), _messageList()],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _topBar() {
    return TopBar(
      fontSize: 24,
      widget.chat.chatTitle(),
      primaryAction: IconButton(
        onPressed: () {},
        icon: Icon(Icons.delete, color: Color.fromRGBO(0, 82, 218, 1.0)),
      ),
      secondaryAction: IconButton(
        onPressed: () {
          _navigation.goBack();
        },
        icon: Icon(
          Icons.arrow_back_ios,
          color: Color.fromRGBO(0, 82, 218, 1.0),
        ),
      ),
    );
  }

  Widget _messageList() {
    if (_chatPageProvider.messages != null) {
      if (_chatPageProvider.messages!.isNotEmpty) {
        return Container(
          height: _deviceHeight * 0.74,
          child: ListView.builder(
            controller: _messageListViewController,
            itemCount: _chatPageProvider.messages!.length,
            itemBuilder: (BuildContext context, int index) {
              ChatMessage message = _chatPageProvider.messages![index];
              bool isOwnMessage = message.senderId == _auth.user.uId;
              return Container(
                child: CustomChatListViewTile(
                  height: _deviceHeight,
                  width: _deviceHeight * 0.80,
                  isOwnMessage: isOwnMessage,
                  message: message,
                  sender:
                      widget.chat.members
                          .where((m) => m.uId == message.senderId)
                          .first,
                ),
              );
            },
          ),
        );
      } else {
        return Align(
          alignment: Alignment.center,
          child: Text(
            "No messages yet",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        );
      }
    } else {
      return Center(child: CircularProgressIndicator(color: Colors.white));
    }
  }
}
