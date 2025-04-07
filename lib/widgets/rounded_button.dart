import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String name;
  final double height;
  final double width;
  final Function onPressed;

  const RoundedButton({
    super.key,
    required this.name,
    required this.height,
    required this.width,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.blue,

        borderRadius: BorderRadius.circular(height * 0.25),
      ),
      child: TextButton(
        onPressed: () {},
        child: Text(
          name,
          style: TextStyle(color: Colors.white, fontSize: 22, height: 1.5),
        ),
      ),
    );
  }
}
