import 'package:do_chat/model/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class TextMessageBubble extends StatelessWidget {
  final bool isOwnMessage;
  final ChatMessage message;
  final double height;
  final double width;

  const TextMessageBubble({
    super.key,
    required this.isOwnMessage,
    required this.message,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    List<Color> _colorSchema =
        isOwnMessage
            ? [
              const Color.fromRGBO(0, 135, 249, 1.0),
              const Color.fromRGBO(0, 82, 218, 1.0),
            ]
            : [
              const Color.fromRGBO(51, 49, 68, 1.0),
              const Color.fromRGBO(51, 49, 68, 1.0),
            ];
    return Container(
      height: height + (message.content.length / 20 * 6.0),
      width: width * 0.4,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          colors: _colorSchema,
          stops: [0.30, 0.70],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message.content,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          ),
          Text(
            "   ${timeago.format(message.sentTime)}",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class ImageMessageBubble extends StatelessWidget {
  final bool isOwnMessage;
  final ChatMessage message;
  final double height;
  final double width;

  const ImageMessageBubble({
    super.key,
    required this.isOwnMessage,
    required this.message,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    List<Color> _colorSchema =
        isOwnMessage
            ? [
              const Color.fromRGBO(0, 135, 249, 1.0),
              const Color.fromRGBO(0, 82, 218, 1.0),
            ]
            : [
              const Color.fromRGBO(51, 49, 68, 1.0),
              const Color.fromRGBO(51, 49, 68, 1.0),
            ];

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.01,
        vertical: height * 0.01,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: _colorSchema,
          stops: [0.30, 0.70],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              message.content,
              height: height * 0.3,
              width: width * 0.4,
              fit: BoxFit.cover,
              alignment: Alignment.center,
              filterQuality: FilterQuality.medium,
              repeat: ImageRepeat.noRepeat,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value:
                        loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                (loadingProgress.expectedTotalBytes ?? 1)
                            : null,
                  ),
                );
              },
              errorBuilder:
                  (context, error, stackTrace) => Icon(
                    Icons.broken_image,
                    size: height * 0.3,
                    color: Colors.white70,
                  ),
            ),
          ),
          SizedBox(height: height * 0.01),
          Text(
            "   ${timeago.format(message.sentTime)}",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
