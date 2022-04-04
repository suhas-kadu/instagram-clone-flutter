import 'package:flutter/material.dart';
import 'package:instagram_clone_flutter/utils/colors.dart';

class FollowButton extends StatelessWidget {
  final Function()? function;
  final String text;
  final Color borderColor;
  final Color bgColor;

  const FollowButton(
      {this.function,
      required this.text,
      required this.borderColor,
      required this.bgColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: TextButton(
        onPressed: function,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          alignment: Alignment.center,
          width: 250,
          decoration: BoxDecoration(
              color: bgColor,
              border: Border.all(color: borderColor, width: 1),
              borderRadius: BorderRadius.circular(6)),
          child: Text(
            text,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
