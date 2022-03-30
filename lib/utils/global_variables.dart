import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_flutter/views/add_a_post_screen.dart';
import 'package:instagram_clone_flutter/views/feed_screen.dart';
import 'package:url_launcher/url_launcher.dart';

const webScreenSize = 600;

List<Widget> screens = [
  FeedScreen(),
  Text("Home1"),
  AddAPostScreen(),
  Text("Home3"),
  Text("Home4"),
];
