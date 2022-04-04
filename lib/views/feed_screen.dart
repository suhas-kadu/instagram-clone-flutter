import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instagram_clone_flutter/utils/colors.dart';
import 'package:instagram_clone_flutter/utils/global_variables.dart';
import 'package:instagram_clone_flutter/utils/utils.dart';
import 'package:instagram_clone_flutter/views/add_a_post_screen.dart';
import 'package:instagram_clone_flutter/widgets/post_card.dart';
import 'package:instagram_clone_flutter/widgets/stories_list.dart';

class FeedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: true,
        leading: IconButton(
            padding: const EdgeInsets.only(
              left: 8.0,
              top: 0,
            ),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddAPostScreen())),
            icon: const FaIcon(FontAwesomeIcons.plusSquare)),
        title: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: SvgPicture.asset(
            "assets/images/instagram_logo.svg",
            color: primaryColor,
            height: 32,
          ),
        ),
        actions: [
          IconButton(
              padding: const EdgeInsets.only(top: 8, right: 16),
              onPressed: () {},
              icon: const FaIcon(FontAwesomeIcons.facebookMessenger))
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("posts").snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return circularProgressIndicator;
          }
          // if (snapshot.hasError) {
          //   return showSnackBar(context, snapshot.error.toString());
          // }

          return SingleChildScrollView(
            child: Column(
              children: [
                StoriesList(),
                ListView.builder(
                    // check this code again
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return PostCard(snap: snapshot.data!.docs[index].data());
                    }),
              ],
            ),
          );
        },
      ),
    );
  }
}
