import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TopBar extends StatelessWidget {
  String title;

  Widget? primaryAction;
  Widget? secondaryAction;
  double? fontSize;
  Color? backgroundColor;

  late double _deviceHeight;
  late double _deviceWidth;

  TopBar(
    this.title, {
    super.key,
    this.fontSize = 30,
    this.primaryAction,
    this.secondaryAction,

    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    return _buildUI();
  }

  Widget _buildUI() {
    return SizedBox(
      height: _deviceHeight * 0.10,
      width: _deviceWidth,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (secondaryAction != null) secondaryAction!,
          _titleBar(),
          if (primaryAction != null) primaryAction!,
        ],
      ),
    );
  }

  Widget _titleBar() {
    return Text(
      title,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: fontSize ?? 20,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
    );
  }
}
