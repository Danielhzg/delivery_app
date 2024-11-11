class Comment {
  final int id;
  final String userId;
  final String content;
  final int rating;

  Comment({
    required this.id,
    required this.userId,
    required this.content,
    required this.rating,
  });

  // Convert from Map to Comment object
  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'],
      userId: map['userId'],
      content: map['content'],
      rating: map['rating'],
    );
  }

  // Convert from Comment object to Map (used for insert/update)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'content': content,
      'rating': rating,
    };
  }
}
