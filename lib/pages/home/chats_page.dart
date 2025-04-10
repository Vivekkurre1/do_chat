import 'package:do_chat/providers/auth_provider.dart';
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
  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _authProvider = Provider.of<AuthProvider>(context);
    return _buildUI();
  }

  Widget _buildUI() {
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
          CustomListViewTileWithActivity(
            height: _deviceHeight * .10,
            title: "Vivek Kurre",
            subtitle: "Hello vivek.",
            imageUrl:
                "https://res.cloudinary.com/dnjeaojih/image/upload/v1744290801/person_image_cgkkwx.webp",
            isActive: false,
            isActivity: false,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
