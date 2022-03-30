import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone_flutter/models/comment.dart';
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
          'likes': FieldValue.arrayUnion([uid])
        });
      }

      res = "success";
    } catch (e) {
      print("error " + e.toString());
      return e.toString();
    }

    return res;
  }

  Future<String> postComment({required Comment comment}) async {
    String res = "Some error occurred";

    try {
      String commentId = const Uuid().v1();
      if (comment.description.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it
        String commentId = const Uuid().v1();
        FirebaseFirestore.instance
            .collection('posts')
            .doc(comment.postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'postId': comment.postId,
          'profileImage': comment.profileImage,
          'username': comment.username,
          'uid': comment.uid,
          'description': comment.description,
          'commentId': commentId,
          'datePublished': comment.datePublished,
          'likes': comment.likes,
        });
        res = "success";
      } else {
        res = "Please enter some text";
      }
    } catch (e) {
      print("error in posting comment: ${e.toString()}");
      return e.toString();
    }

    return res;
  }

  Future<String> updateCommentLikes(
      String postId, String commentId, String uid, List likes) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(uid)) {
        await FirebaseFirestore.instance
            .collection("posts")
            .doc(postId)
            .collection("comments")
            .doc(commentId)
            .update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await FirebaseFirestore.instance
            .collection("posts")
            .doc(postId)
            .collection("comments")
            .doc(commentId)
            .update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }

      res = "success";
    } catch (e) {
      print("error " + e.toString());
      return e.toString();
    }

    return res;
  }

  Future<String> deletePost(String postId) async {
    String res = "Some error occured";

    try {
      await FirebaseFirestore.instance.collection("posts").doc(postId).delete();
      res = "success";
    } catch (e) {
      print(e.toString());
      return e.toString();
    }

    return res;
  }
}
