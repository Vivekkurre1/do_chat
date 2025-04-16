import 'package:do_chat/providers/auth_provider.dart';
import 'package:do_chat/widgets/custom_input_fields.dart';
import 'package:do_chat/widgets/custom_list_view.dart';
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

  final TextEditingController _searchFireldEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthProvider>(context);
    return _buildUI();
  }

  Widget _buildUI() {
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
            onEditingComplete: (value) {},
            icon: Icons.search,
          ),
          _usersList(),
        ],
      ),
    );
  }

  Widget _usersList() {
    return Expanded(
      child: () {
        return ListView.builder(
          itemCount: 10,
          itemBuilder: (BuildContext context, index) {
            return CustomListViewTile(
              height: _deviceHeight * 0.10,
              title: "User",
              subtitle: "Last Active",
              imageUrl: "https://i.pravatar.cc/300",
              isActive: false,
              isSelected: false,
              onTap: () {},
            );
          },
        );
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
}
