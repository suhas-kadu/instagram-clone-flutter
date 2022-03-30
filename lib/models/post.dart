import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String uid;
  String username;
  String profileImage;
  String postId;
  String postUrl;
  final datePublished;
  String description;
  final likes;

  Post({
    required this.uid,
    required this.description,
    required this.postId,
    required this.postUrl,
    required this.profileImage,
    required this.username,
    required this.datePublished,
    required this.likes,
  });

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "username": username,
      "postId": postId,
      "postUrl": postUrl,
      "profileImage": profileImage,
      "datePublished": datePublished,
      "description": description,
      "likes": likes,
    };
  }

  static Post fromSnap(DocumentSnapshot documentSnapshot) {
    var snapshot = (documentSnapshot.data() as Map<String, dynamic>);

    return Post(
        uid: snapshot["uid"],
        description: snapshot["description"],
        postId: snapshot["postId"],
        postUrl: snapshot["postUrl"],
        profileImage: snapshot["profileImage"],
        username: snapshot["username"],
        datePublished: snapshot["datePublished"],
        likes: snapshot["likes"]);
  }
}
