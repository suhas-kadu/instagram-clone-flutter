import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_flutter/models/comment.dart';
import 'package:instagram_clone_flutter/models/user.dart';
import 'package:instagram_clone_flutter/resources/firestore_methods.dart';
import 'package:instagram_clone_flutter/utils/colors.dart';
import 'package:instagram_clone_flutter/utils/global_variables.dart';
import 'package:instagram_clone_flutter/utils/utils.dart';
import 'package:instagram_clone_flutter/widgets/comment_card.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

class CommentsScreen extends StatefulWidget {
  String postId;
  CommentsScreen({Key? key, required this.postId}) : super(key: key);

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text("Comments"),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("posts")
              .doc(widget.postId)
              .collection("comments")
              .snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return circularProgressIndicator;
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                return CommentCard(snap: snapshot.data!.docs[index]);
              },
            );
          }),
      bottomNavigationBar: Container(
        height: kToolbarHeight,
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user.photoUrl),
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: TextField(
                  textAlign: TextAlign.start,
                  controller: _commentController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Comment as ${user.username}"),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              InkWell(
                onTap: () {
                  postComment(user.uid, _commentController.text.trim(),
                      user.photoUrl, widget.postId.toString(), user.username);
                },
                child: const Text(
                  "Post",
                  style: TextStyle(color: Colors.blue),
                ),
              )
            ],
          ),
        )),
      ),
    );
  }

  void postComment(String uid, String description, String profileImage,
      String postId, String username) async {
    String res = await FireStoreMethods().postComment(
        comment: Comment(
            uid: uid,
            description: description,
            postId: postId,
            profileImage: profileImage,
            username: username,
            datePublished: DateTime.now(),
            likes: []));

    if (res == "success") {
      showSnackBar(context, "Comment Posted Successfully");

      setState(() {
        _commentController.clear();
      });
    } else {
      showSnackBar(context, res);
    }
  }
}
