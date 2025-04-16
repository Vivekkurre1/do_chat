import 'package:do_chat/model/chat_user.dart';
import 'package:do_chat/providers/auth_provider.dart';
import 'package:do_chat/providers/users_page_provider.dart';
import 'package:do_chat/widgets/custom_input_fields.dart';
import 'package:do_chat/widgets/custom_list_view.dart';
import 'package:do_chat/widgets/rounded_button.dart';
import 'package:do_chat/widgets/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  late double _deviceHeight;
  late double _deviceWidth;

  late AuthProvider _auth;
  late UsersPageProvider _usersPageProvider;

  final TextEditingController _searchFireldEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthProvider>(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UsersPageProvider>(
          create: (_) => UsersPageProvider(_auth),
        ),
      ],
      child: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Builder(
      builder: (BuildContext context) {
        _usersPageProvider = context.watch<UsersPageProvider>();
        return Container(
          height: _deviceHeight,
          width: _deviceWidth,
          padding: EdgeInsets.fromLTRB(
            _deviceWidth * 0.02,
            _deviceHeight * 0.02,
            _deviceWidth * 0.02,
            _deviceHeight * 0.00,
          ),

          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _topBar(),
              CustomTextField(
                controller: _searchFireldEditingController,
                hintText: "Search...",
                obscureText: false,
                onEditingComplete: (value) {
                  _usersPageProvider.getUsers(name: value);
                  FocusScope.of(context).unfocus();
                },
                icon: Icons.search,
              ),
              _usersList(),
              _createChatButton(),
            ],
          ),
        );
      },
    );
  }

  Widget _usersList() {
    List<ChatUser>? _users = _usersPageProvider.users;
    return Expanded(
      child: () {
        if (_users != null) {
          if (_users.length != 0) {
            return ListView.builder(
              itemCount: _users.length,
              itemBuilder: (BuildContext context, index) {
                return CustomListViewTile(
                  height: _deviceHeight * 0.10,
                  title: _users[index].name,
                  subtitle: "Last Active: ${_users[index].lastDayActive()}",
                  imageUrl: _users[index].imageUrl,
                  isActive: _users[index].wasRecentlyActive(),
                  isSelected: _usersPageProvider.selectedUsers.contains(
                    _users[index],
                  ),
                  onTap: () {
                    _usersPageProvider.updateSearchedUsers(_users[index]);
                  },
                );
              },
            );
          } else {
            return Center(
              child: Text(
                "No users found",
                style: TextStyle(color: Colors.white),
              ),
            );
          }
        } else {
          return Center(child: CircularProgressIndicator(color: Colors.white));
        }
      }(),
    );
  }

  Widget _topBar() {
    return TopBar(
      "Users",
      primaryAction: IconButton(
        onPressed: () {
          _auth.logout();
        },
        icon: Icon(Icons.logout_outlined),
        color: Colors.white,
      ),
    );
  }

  Widget _createChatButton() {
    return Visibility(
      visible: _usersPageProvider.selectedUsers.isNotEmpty,
      child: RoundedButton(
        height: _deviceHeight * 0.06,
        width: _deviceWidth * 0.60,
        name:
            _usersPageProvider.selectedUsers.length == 1
                ? "Chat With ${_usersPageProvider.selectedUsers.first.name}"
                : "Create Group Chat",
        onPressed: () {
          _usersPageProvider.createChat();
        },
        // key: UniqueKey(),
      ),
    );
  }
}
