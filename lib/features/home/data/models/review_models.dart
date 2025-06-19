class ReviewPost {
  final String id;
  final String authorName;
  final String authorAvatar;
  final String timeAgo;
  final double rating;
  final String route;
  final String airline;
  final String flightClass;
  final String travelMonth;
  final String content;
  final List<String> images;
  final int likes;
  final int comments;
  final bool isLiked;

  const ReviewPost({
    required this.id,
    required this.authorName,
    required this.authorAvatar,
    required this.timeAgo,
    required this.rating,
    required this.route,
    required this.airline,
    required this.flightClass,
    required this.travelMonth,
    required this.content,
    required this.images,
    required this.likes,
    required this.comments,
    this.isLiked = false,
  });
}

class Comment {
  final String id;
  final String authorName;
  final String authorAvatar;
  final String content;
  final String timeAgo;
  final int upvotes;

  const Comment({
    required this.id,
    required this.authorName,
    required this.authorAvatar,
    required this.content,
    required this.timeAgo,
    required this.upvotes,
  });
}
