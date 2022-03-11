class User {
  final String email;
  final String password;
  final String photoUrl;
  final String bio;
  final String uid;
  final List followers;
  final List following;

  User(
      {required this.email,
      required this.password,
      required this.photoUrl,
      required this.bio,
      required this.uid,
      required this.followers,
      required this.following});

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "password": password,
      "photoUrl": photoUrl,
      "bio": bio,
      "uid": uid,
      "followers": followers,
      "following": following,
    };
  }
}
