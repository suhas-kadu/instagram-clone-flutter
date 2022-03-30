import 'package:flutter/material.dart';
import 'package:instagram_clone_flutter/models/user.dart';
import 'package:instagram_clone_flutter/providers/user_provider.dart';
import 'package:instagram_clone_flutter/resources/firestore_methods.dart';
import 'package:instagram_clone_flutter/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CommentCard extends StatefulWidget {
  final snap;

  const CommentCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;

    bool isCommentLiked = widget.snap["likes"].contains(user.uid);
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(widget.snap["profileImage"]),
      ),
      title: RichText(
          text: TextSpan(children: [
        TextSpan(
            text: "${widget.snap["username"]}",
            style: const TextStyle(fontWeight: FontWeight.bold)),
        TextSpan(text: "  ${widget.snap["description"]}"),
      ])),
      trailing: LikeAnimation(
        isAnimating: isCommentLiked,
        smallLike: true,
        child: IconButton(
            tooltip: isCommentLiked ? "Unlike" : "Like",
            onPressed: () async {
              String res = await FireStoreMethods().updateCommentLikes(
                  widget.snap["postId"],
                  widget.snap["commentId"],
                  user.uid,
                  widget.snap["likes"]);
              print(res);
            },
            icon: isCommentLiked
                ? const Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: 16,
                  )
                : const Icon(
                    Icons.favorite_outline,
                    size: 16,
                  )),
      ),
      subtitle: Row(
        children: [
          Text(
              DateFormat.yMMMd().format(widget.snap["datePublished"].toDate())),
          const SizedBox(
            width: 32,
          ),
          Text("${widget.snap["likes"].length} likes"),
        ],
      ),
    );
  }
}
