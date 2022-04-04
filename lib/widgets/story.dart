import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';

class Story extends StatelessWidget {
  const Story({
    Key? key,
    required this.imageUrl,
    required this.username,
  }) : super(key: key);

  final String imageUrl;
  final String username;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      // child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          FadeIn(
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.green, width: 2),
                  shape: BoxShape.circle),
              padding: const EdgeInsets.all(4),
              child: CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(imageUrl),
              ),
            ),
          ),
          Text(
            username,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
      // ),
    );
  }
}
