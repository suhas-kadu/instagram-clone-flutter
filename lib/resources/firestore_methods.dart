import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_flutter/models/post.dart';
import 'package:instagram_clone_flutter/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethods {
  Future<String> uploadPost(String uid, String username, String profileImage,
      Uint8List file, String description) async {
    String res = "Some error occurred";

    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage("posts", file, true);
      String postId = const Uuid().v1();

      Post post = Post(
          uid: uid,
          description: description,
          postId: postId,
          postUrl: photoUrl,
          profileImage: profileImage,
          username: username,
          datePublished: DateTime.now(),
          likes: []);

      await FirebaseFirestore.instance
          .collection("posts")
          .doc(postId)
          .set(post.toJson());

      res = "success";
    } catch (e) {
      print("error: ${e.toString()}");
      return e.toString();
    }

    return res;
  }

  Future<String> updateLikes(String postId, String uid, List likes) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(uid)) {
        await FirebaseFirestore.instance
            .collection("posts")
            .doc(postId)
            .update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await FirebaseFirestore.instance
            .collection("posts")
            .doc(postId)
            .update({
          'likes':
            FieldValue.arrayUnion([uid])

        });
      }

      res = "success";
    } catch (e) {
      print("error "+e.toString());
      return e.toString();
    }

    return res;
  }
}
