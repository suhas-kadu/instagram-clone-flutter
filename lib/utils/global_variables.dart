import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_flutter/views/add_a_post_screen.dart';
import 'package:instagram_clone_flutter/views/feed_screen.dart';
import 'package:instagram_clone_flutter/views/notifications_screen.dart';
import 'package:instagram_clone_flutter/views/profile_screen.dart';
import 'package:instagram_clone_flutter/views/search_screen.dart';

const webScreenSize = 600;

List<Widget> screens = [
  FeedScreen(),
  const SearchScreen(),
  AddAPostScreen(),
  const NotificationsScreen(),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];

const Widget circularProgressIndicator = Center(
  child: CircularProgressIndicator.adaptive(),
);
