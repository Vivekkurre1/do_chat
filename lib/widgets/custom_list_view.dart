import 'package:do_chat/model/chat_message.dart';
import 'package:do_chat/model/chat_user.dart';
import 'package:do_chat/widgets/rounded_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomListViewTileWithActivity extends StatelessWidget {
  final double height;
  final String title;
  final String subtitle;
  final String imageUrl;
  final bool isActive;
  final bool isActivity;
  final Function onTap;

  const CustomListViewTileWithActivity({
    super.key,
    required this.height,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.isActive,
    required this.isActivity,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => onTap(),
      leading: RoundedImageNetworkWithStatusIndicator(
        key: UniqueKey(),
        imagePath: imageUrl,
        size: height / 2,
        isActive: isActive,
      ),
      minVerticalPadding: height * 0.20,
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle:
          isActivity
              ? Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SpinKitThreeBounce(
                    color: Colors.white54,
                    size: height * 0.10,
                  ),
                ],
              )
              : Text(
                subtitle,
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
    );
  }
}

class CustomChatListViewTile extends StatelessWidget {
  final double height;
  final double width;
  final bool isOwnMessage;
  final ChatMessage message;
  final ChatUser sender;

  const CustomChatListViewTile({
    super.key,
    required this.height,
    required this.width,
    required this.isOwnMessage,
    required this.message,
    required this.sender,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      width: width,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment:
            isOwnMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          !isOwnMessage
              ? RoundedImageNetwork(
                key: UniqueKey(),
                imagePath: sender.imageUrl,
                size: height * 0.04,
              )
              : Container(),

          SizedBox(width: width * 0.05),
          message.type == MessageType.text
              ? Text(message.content)
              : Text(message.content),
        ],
      ),
    );
  }
}
