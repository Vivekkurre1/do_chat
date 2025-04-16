import 'package:do_chat/model/chat.dart';
import 'package:do_chat/model/chat_message.dart';
import 'package:do_chat/providers/auth_provider.dart';
import 'package:do_chat/providers/chat_page_provider.dart';
import 'package:do_chat/services/navigation_service.dart';
import 'package:do_chat/widgets/custom_input_fields.dart';
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
            physics: const BouncingScrollPhysics(),
            child: Container(
              padding: EdgeInsets.fromLTRB(
                _deviceWidth * 0.02,
                _deviceHeight * 0.02,
                _deviceWidth * 0.02,
                _deviceHeight * 0.00,
              ),
              height: _deviceHeight,
              width: _deviceWidth,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [_topBar(), _messageList(), _sendMessageForm()],
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
        onPressed: () {
          _chatPageProvider.deleteChat();
        },
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
        return SizedBox(
          height: _deviceHeight * 0.76,
          child: ListView.builder(
            controller: _messageListViewController,
            itemCount: _chatPageProvider.messages!.length,
            itemBuilder: (BuildContext context, int index) {
              ChatMessage message = _chatPageProvider.messages![index];
              bool isOwnMessage = message.senderId == _auth.user.uId;
              return CustomChatListViewTile(
                height: _deviceHeight,
                width: _deviceHeight * 0.80,
                isOwnMessage: isOwnMessage,
                message: message,
                sender:
                    widget.chat.members
                        .where((m) => m.uId == message.senderId)
                        .first,
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

  Widget _sendMessageForm() {
    return Container(
      height: _deviceHeight * 0.06,
      decoration: BoxDecoration(
        color: Color.fromRGBO(30, 29, 37, 1.0),
        borderRadius: BorderRadius.circular(100),
      ),
      margin: EdgeInsets.symmetric(
        vertical: _deviceHeight * 0.03,
        horizontal: _deviceWidth * 0.01,
      ),
      child: Form(
        key: _messageFormState,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _messageTextField(),
            _sendMessageButton(),
            _imageMessageButton(),
          ],
        ),
      ),
    );
  }

  Widget _messageTextField() {
    return SizedBox(
      width: _deviceWidth * 0.65,
      child: CustomTextFormField(
        onSaved: (value) {
          _chatPageProvider.message = value;
        },
        regEx: r"^(?!\s*$).+",
        hintText: "Type a message",
        obscureText: false,
      ),
    );
  }

  Widget _sendMessageButton() {
    double size = _deviceHeight * 0.04;
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        // color: Color.fromRGBO(0, 82, 218, 1.0),
        borderRadius: BorderRadius.circular(size / 2),
      ),

      child: IconButton(
        onPressed: () {
          if (_messageFormState.currentState!.validate()) {
            _messageFormState.currentState!.save();
            _chatPageProvider.sendTextMessage();
            _messageFormState.currentState!.reset();
          }
        },
        icon: Icon(Icons.send, color: Colors.white),
      ),
    );
  }

  Widget _imageMessageButton() {
    double size = _deviceHeight * 0.04;
    return SizedBox(
      height: size,
      width: size,
      child: FloatingActionButton(
        backgroundColor: Color.fromRGBO(0, 82, 218, 1.0),
        onPressed: () {
          _chatPageProvider.sendImageMessage();
        },
        child: Icon(Icons.camera, color: Colors.white),
      ),
    );
  }
}
