class Comment {
  String uid;
  String username;
  String profileImage;
  String postId;
  final datePublished;
  String description;
  final likes;

  Comment({
    required this.uid,
    required this.description,
    required this.postId,
    required this.profileImage,
    required this.username,
    required this.datePublished,
    required this.likes,
  });
}
