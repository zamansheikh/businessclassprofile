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
  final String type; // 'share' or 'ask'
  final DateTime publishedDate;
  final PostAuthor? authorInfo;
  final List<PostComment> postComments;

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
    this.type = 'share',
    required this.publishedDate,
    this.authorInfo,
    this.postComments = const [],
  });

  factory ReviewPost.fromJson(Map<String, dynamic> json) {
    final departure = json['departure'] ?? {};
    final arrival = json['arrival'] ?? {};
    final airline = json['airline'] ?? {};
    final authorInfo = json['author_info'] ?? {};

    // Build route string
    final departureCode = departure['iata'] ?? '';
    final arrivalCode = arrival['iata'] ?? '';
    final route = '$departureCode - $arrivalCode';

    // Build airline name
    final airlineName =
        airline['name'] ?? 'Unknown Airline'; // Build author avatar URL
    final profileUrl = authorInfo['profileUrl'];
    final authorAvatar = ApiImageHelper.getProfileImageUrl(profileUrl);

    // Build image URLs
    final files = List<String>.from(json['files'] ?? []);
    final images = files
        .map((file) => ApiImageHelper.getPostImageUrl(file))
        .toList();

    // Calculate time ago
    final publishedDate = DateTime.parse(json['published_date']);
    final timeAgo = _calculateTimeAgo(publishedDate);

    // Parse comments
    final commentsJson = List<Map<String, dynamic>>.from(
      json['comments'] ?? [],
    );
    final postComments = commentsJson
        .where((comment) => comment['comment_text'] != null)
        .map((comment) => PostComment.fromJson(comment))
        .toList();

    return ReviewPost(
      id: json['_id'] ?? '',
      authorName:
          authorInfo['display_name'] ??
          authorInfo['username'] ??
          'Unknown User',
      authorAvatar: authorAvatar,
      timeAgo: timeAgo,
      rating: (json['rating'] ?? 0).toDouble(),
      route: route,
      airline: airlineName,
      flightClass: json['class_type'] ?? 'Unknown',
      travelMonth: _formatTravelMonth(json['share_date']),
      content: json['description'] ?? '',
      images: images,
      likes: json['react'] ?? 0,
      comments: json['comment_count'] ?? 0,
      isLiked: false, // Will be determined based on current user
      type: json['type'] ?? 'share',
      publishedDate: publishedDate,
      authorInfo: PostAuthor.fromJson(authorInfo),
      postComments: postComments,
    );
  }

  static String _calculateTimeAgo(DateTime publishedDate) {
    final now = DateTime.now();
    final difference = now.difference(publishedDate);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  static String _formatTravelMonth(String? shareDateStr) {
    if (shareDateStr == null) return 'Unknown';
    try {
      final shareDate = DateTime.parse(shareDateStr);
      final months = [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December',
      ];
      return '${months[shareDate.month - 1]} ${shareDate.year}';
    } catch (e) {
      return 'Unknown';
    }
  }
}

class PostAuthor {
  final String id;
  final String username;
  final String displayName;
  final String email;
  final String? profileUrl;

  const PostAuthor({
    required this.id,
    required this.username,
    required this.displayName,
    required this.email,
    this.profileUrl,
  });

  factory PostAuthor.fromJson(Map<String, dynamic> json) {
    return PostAuthor(
      id: json['_id'] ?? '',
      username: json['username'] ?? '',
      displayName: json['display_name'] ?? json['displayName'] ?? '',
      email: json['email'] ?? '',
      profileUrl: json['profileUrl'],
    );
  }
}

class PostComment {
  final String id;
  final String authorName;
  final String authorAvatar;
  final String content;
  final String timeAgo;
  final int upvotes;
  final List<String> upvotedUsers;
  final PostAuthor? authorInfo;

  const PostComment({
    required this.id,
    required this.authorName,
    required this.authorAvatar,
    required this.content,
    required this.timeAgo,
    required this.upvotes,
    this.upvotedUsers = const [],
    this.authorInfo,
  });

  factory PostComment.fromJson(Map<String, dynamic> json) {
    final authorInfo = json['author_info'] ?? {};
    final profileUrl = authorInfo['profileUrl'];
    final authorAvatar = profileUrl != null
        ? ApiImageHelper.getProfileImageUrl(profileUrl)
        : '';

    // Calculate time ago
    final dateStr = json['date'];
    final timeAgo = dateStr != null
        ? ReviewPost._calculateTimeAgo(DateTime.parse(dateStr))
        : 'Unknown';

    return PostComment(
      id: json['id'] ?? '',
      authorName:
          authorInfo['displayName'] ?? authorInfo['username'] ?? 'Unknown User',
      authorAvatar: authorAvatar,
      content: json['comment_text'] ?? '',
      timeAgo: timeAgo,
      upvotes: json['upvotes'] ?? 0,
      upvotedUsers: List<String>.from(json['upvoted_users'] ?? []),
      authorInfo: PostAuthor.fromJson(authorInfo),
    );
  }
}

// Keep the old Comment class for backward compatibility
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

class ApiImageHelper {
  static const String _baseImageUrl =
      'https://businessclassprofile.com/api/feed_api/get_image';
  static const String _baseProfileUrl =
      'https://businessclassprofile.com/api/feed_api/get_image';

  static String getPostImageUrl(String fileName) {
    if (fileName.isEmpty) return '';
    return '$_baseImageUrl/$fileName';
  }

  static String getProfileImageUrl(String? fileName) {
    if (fileName == null || fileName.isEmpty) return '';
    return '$_baseProfileUrl/$fileName';
  }
}
