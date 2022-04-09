import 'dart:math';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instagram_clone_flutter/providers/user_provider.dart';
import 'package:instagram_clone_flutter/resources/firestore_methods.dart';
import 'package:instagram_clone_flutter/utils/utils.dart';
import 'package:instagram_clone_flutter/views/comments_screen.dart';
import 'package:instagram_clone_flutter/views/profile_screen.dart';
import 'package:instagram_clone_flutter/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:instagram_clone_flutter/models/user.dart';

class PostCard extends StatefulWidget {
  final snap;

  const PostCard({required this.snap});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;

  didLikeUpdate(String postId, String uid, List likes) async {
    String res = await FireStoreMethods().updateLikes(postId, uid, likes);

    if (res != "success") showSnackBar(context, res);
  }

  addAndViewComments() => Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => CommentsScreen(
            postId: widget.snap["postId"],
          )));

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    bool isPostLiked = widget.snap["likes"].contains(user.uid);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // GestureDetector(

          // child:
          ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) =>
                          ProfileScreen(uid: widget.snap["uid"]))));
            },
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
            leading: Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(
                    "https://t4.ftcdn.net/jpg/02/15/84/43/240_F_215844325_ttX9YiIIyeaR7Ne6EaLLjMAmy4GvPC69.jpg"),
                foregroundImage: NetworkImage(
                  widget.snap["profileImage"],
                ),
              ),
            ),
            title: Text(widget.snap["username"]),
            trailing: IconButton(
              tooltip: "More Options",
              padding: EdgeInsets.zero,
              icon: const FaIcon(
                Icons.more_vert,
                size: 28,
              ),
              onPressed: () {
                _showOptions(context);
              },
            ),
          ),
          // ),
          GestureDetector(
            onDoubleTap: () async {
              await didLikeUpdate(widget.snap["postId"].toString(), user.uid,
                  widget.snap["likes"]);
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: loadNetworkImage(
                        context,
                        widget.snap["postUrl"],
                        "",
                        MediaQuery.of(context).size.width,
                        MediaQuery.of(context).size.height * 0.4)),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                    isAnimating: isLikeAnimating,
                    child: const Icon(
                      Icons.favorite,
                      size: 100,
                      color: Colors.white,
                    ),
                    duration: const Duration(milliseconds: 400),
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                  ),
                )
              ],
            ),
          ),
          Row(
            children: [
              LikeAnimation(
                isAnimating: isPostLiked,
                smallLike: true,
                onEnd: () {},
                child: IconButton(
                  tooltip: isPostLiked ? "Unlike" : "Like",
                  onPressed: () async {
                    await didLikeUpdate(widget.snap["postId"].toString(),
                        user.uid, widget.snap["likes"]);
                    setState(() {
                      isLikeAnimating = true;
                    });
                  },
                  icon: isPostLiked
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.red,
                          size: 28,
                        )
                      : const Icon(
                          Icons.favorite_outline_rounded,
                          size: 28,
                        ),
                ),
              ),
              IconButton(
                  tooltip: "Comment",
                  onPressed: () => addAndViewComments(),
                  icon: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(pi),
                      child: const FaIcon(FontAwesomeIcons.comment))),
              IconButton(
                  tooltip: "Share",
                  onPressed: () {
                    launchUrl(widget.snap["postUrl"]);
                  },
                  icon: Transform.rotate(
                      angle: -pi / 4, child: const FaIcon(Icons.send))),
              const Spacer(),
              IconButton(
                  tooltip: "Save",
                  padding: const EdgeInsets.only(right: 6),
                  onPressed: () {},
                  icon: const FaIcon(FontAwesomeIcons.bookmark))
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 8,
                ),
                RichText(
                  textAlign: TextAlign.start,
                  softWrap: true,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    text: widget.snap["likes"].length.toString() + " likes",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                    children: <TextSpan>[
                      TextSpan(
                        text: "\n" + widget.snap["username"],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      TextSpan(
                          text: " " + widget.snap["description"],
                          style: const TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 16)),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                InkWell(
                    onTap: () => addAndViewComments(),
                    child: const Text(
                      "View all comments",
                      style: TextStyle(color: Colors.grey),
                    )),
                const SizedBox(
                  height: 6,
                ),
                Text(DateFormat.yMMMd()
                    .format((widget.snap["datePublished"]).toDate()))
              ],
            ),
          )
        ],
      ),
    );
  }

  _showOptions(BuildContext context) {
    final User user = Provider.of<UserProvider>(context, listen: false).getUser;
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            children: [
              widget.snap['uid'].toString() == user.uid
                  ? SimpleDialogOption(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: const Text("Delete"),
                      onPressed: () async {
                        String res = await FireStoreMethods()
                            .deletePost(widget.snap["postId"].toString());
                        Navigator.pop(context);
                      },
                    )
                  : Container(),
              SimpleDialogOption(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: const Text("Copy link"),
                onPressed: () async {
                  await Clipboard.setData(
                      ClipboardData(text: widget.snap["postUrl"].toString()));
                  Navigator.pop(context);
                  showSnackBar(context, "Link copied to clipboard");
                },
              ),
              SimpleDialogOption(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: const Text("View Profile"),
                onPressed: () async {
                  print("view profile pressed");
                  Navigator.pop(context);
                },
              ),
              SimpleDialogOption(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}
