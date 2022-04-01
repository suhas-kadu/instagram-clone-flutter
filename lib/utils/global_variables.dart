import 'package:flutter/material.dart';
import 'package:instagram_clone_flutter/views/add_a_post_screen.dart';
import 'package:instagram_clone_flutter/views/feed_screen.dart';
import 'package:instagram_clone_flutter/views/search_screen.dart';

const webScreenSize = 600;

List<Widget> screens = [
  FeedScreen(),
  const SearchScreen(),
  AddAPostScreen(),
  Text("Home3"),
  Text("Home4"),
];

const Widget circularProgressIndicator = Center(
  child: CircularProgressIndicator.adaptive(),
);
