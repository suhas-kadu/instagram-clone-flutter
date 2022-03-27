import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instagram_clone_flutter/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

class PostCard extends StatelessWidget {
  final snap;

  PostCard({required this.snap});

  @override
  Widget build(BuildContext context) {
    var date = (snap["datePublished"] as Timestamp).toDate();
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
            leading: Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: CircleAvatar(
                backgroundImage: NetworkImage(snap["profileImage"]),
                // radius: 30,
              ),
            ),
            title: Text(snap["username"]),
            trailing: IconButton(
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
          Container(
            color: Colors.white,
            child: Image.network(
              snap["postUrl"],
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.4,
              fit: BoxFit.cover,
            ),
          ),
          Row(
            children: [
              IconButton(
                  // padding: EdgeInsets.zero,
                  onPressed: () {},
                  icon: const FaIcon(FontAwesomeIcons.heart)),
              IconButton(
                  // padding: EdgeInsets.zero,
                  onPressed: () {},
                  icon: const FaIcon(FontAwesomeIcons.comment)),
              IconButton(
                  onPressed: () {},
                  icon: Transform.rotate(
                      angle: -pi / 4, child: const FaIcon(Icons.send))),
              const Spacer(),
              IconButton(
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
                    text: snap["likes"].length.toString() + " likes",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                    children: <TextSpan>[
                      TextSpan(
                        text: "\n" + snap["username"],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      TextSpan(
                          text: snap["description"],
                          style: const TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 16)),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                InkWell(
                    onTap: () {},
                    child: const Text(
                      "View all comments",
                      style: TextStyle(color: Colors.grey),
                    )),
                const SizedBox(
                  height: 6,
                ),
                Text(
                    DateFormat.yMMMd().format((snap["datePublished"]).toDate()))
              ],
            ),
          )
        ],
      ),
    );
  }

  _showOptions(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            children: [
              SimpleDialogOption(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: const Text("Delete"),
                onPressed: () async {
                  print("delete pressed");
                  Navigator.pop(context);
                },
              ),
              SimpleDialogOption(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: const Text("Copy link"),
                onPressed: () async {
                  await Clipboard.setData(
                      ClipboardData(text: snap["postUrl"].toString()));
                  // print(snap["postUrl"]);
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
