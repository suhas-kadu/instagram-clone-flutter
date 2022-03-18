import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String photoUrl;
  final String username;
  final String bio;
  final String uid;
  final List followers;
  final List following;

  User(
      {required this.email,
      required this.photoUrl,
      required this.username,
      required this.bio,
      required this.uid,
      required this.followers,
      required this.following});

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "photoUrl": photoUrl,
      "username": username,
      "bio": bio,
      "uid": uid,
      "followers": followers,
      "following": following,
    };
  }

  static User fromSnap(DocumentSnapshot documentSnapshot) {
    var snapshot = (documentSnapshot.data() as Map<String, dynamic>);

    return User(
        email: snapshot["email"],
        photoUrl: snapshot["photoUrl"],
        username: snapshot["username"],
        bio: snapshot["bio"],
        uid: snapshot["uid"],
        followers: snapshot["followers"],
        following: snapshot["following"]);
  }
}
