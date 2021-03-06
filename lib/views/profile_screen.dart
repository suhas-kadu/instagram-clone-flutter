import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_flutter/resources/firestore_methods.dart';
import 'package:instagram_clone_flutter/utils/colors.dart';
import 'package:instagram_clone_flutter/utils/global_variables.dart';
import 'package:instagram_clone_flutter/utils/static_drawer.dart';
import 'package:instagram_clone_flutter/utils/utils.dart';
import 'package:instagram_clone_flutter/widgets/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  bool isMount = true;
  ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLength = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getData() async {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }

    try {
      var userSnap = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.uid)
          .get();

      // post length
      // model.User user = Provider.of<UserProvider>(context).getUser;

      var postSnap = await FirebaseFirestore.instance
          .collection("posts")
          .where('uid', isEqualTo: widget.uid)
          .get();

      postLength = postSnap.docs.length;
      userData = userSnap.data()!;
      followers = userData["followers"].length;
      following = userData["following"].length;

      isFollowing = userData["followers"]
          .contains(FirebaseAuth.instance.currentUser!.uid);

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }

    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return circularProgressIndicator;
    } else {
      return Scaffold(
        endDrawer: const StaticDrawer(),
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          leading: FirebaseAuth.instance.currentUser!.uid == widget.uid
              ? const Icon(
                  Icons.lock,
                  size: 28,
                )
              : IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 28,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
          title: Text(userData["username"]),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: const NetworkImage(
                          "https://t4.ftcdn.net/jpg/02/15/84/43/240_F_215844325_ttX9YiIIyeaR7Ne6EaLLjMAmy4GvPC69.jpg"),
                      foregroundImage: NetworkImage(userData["photoUrl"]),
                      radius: 40,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16, left: 16),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                statWidget(num: postLength, label: "Posts"),
                                statWidget(num: followers, label: "Followers"),
                                statWidget(num: following, label: "Following"),
                              ],
                            ),
                            FirebaseAuth.instance.currentUser!.uid == widget.uid
                                ? const FollowButton(
                                    text: "Edit Profile",
                                    bgColor: Colors.transparent,
                                    borderColor: primaryColor,
                                  )
                                : (isFollowing
                                    ? FollowButton(
                                        text: "Unfollow",
                                        bgColor: Colors.blue,
                                        borderColor: Colors.blue,
                                        function: () async {
                                          String res = await FireStoreMethods()
                                              .followUnfollowUser(
                                            FirebaseAuth
                                                .instance.currentUser!.uid,
                                            userData['uid'],
                                          );

                                          setState(() {
                                            isFollowing = false;
                                            followers--;
                                          });
                                          if (res != "success") {
                                            showSnackBar(context, res);
                                          }
                                        })
                                    : FollowButton(
                                        text: "Follow",
                                        bgColor: Colors.transparent,
                                        borderColor: primaryColor,
                                        function: () async {
                                          String res = await FireStoreMethods()
                                              .followUnfollowUser(
                                            FirebaseAuth
                                                .instance.currentUser!.uid,
                                            userData['uid'],
                                          );

                                          setState(() {
                                            isFollowing = true;
                                            followers++;
                                          });

                                          if (res != "success") {
                                            showSnackBar(context, res);
                                          }
                                        },
                                      ))
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Text(
                "    " + userData["username"],
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                "    " + userData["bio"] + "\n",
                style: TextStyle(fontSize: 16),
              ),
              const Divider(),
              FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection("posts")
                      .where('uid', isEqualTo: widget.uid)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return circularProgressIndicator;
                    }

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 2,
                              mainAxisSpacing: 2),
                      itemCount: (snapshot.data! as dynamic).docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        DocumentSnapshot snap =
                            (snapshot.data! as dynamic).docs[index];

                        return GridTile(
                            child: CachedNetworkImage(
                          imageUrl: snap["postUrl"],
                          fit: BoxFit.fill,
                        ));
                      },
                    );
                  })
            ],
          ),
        ),
      );
    }
  }

  Column statWidget({required int num, required String label}) {
    return Column(
      children: [
        Text(
          num.toString(),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(label,
            style: const TextStyle(
              fontSize: 16,
            )),
      ],
    );
  }
}
