import 'package:flutter/material.dart';
import '../../data/models/review_models.dart';

class ReviewCard extends StatefulWidget {
  final ReviewPost review;
  final List<Comment> comments;
  final VoidCallback onLike;
  final VoidCallback onShare;
  final VoidCallback onComment;

  const ReviewCard({
    super.key,
    required this.review,
    required this.comments,
    required this.onLike,
    required this.onShare,
    required this.onComment,
  });

  @override
  State<ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  bool _showComments = false;
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.review.isLiked;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildFlightInfo(),
          _buildContent(),
          if (widget.review.images.isNotEmpty) _buildImages(),
          _buildFooter(),
          if (_showComments) _buildComments(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(widget.review.authorAvatar),
            onBackgroundImageError: (exception, stackTrace) {},
            child: widget.review.authorAvatar.isEmpty
                ? const Icon(Icons.person, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.review.authorName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                Text(
                  widget.review.timeAgo,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Row(
            children: List.generate(5, (index) {
              return Icon(
                index < widget.review.rating.floor()
                    ? Icons.star
                    : Icons.star_border,
                color: Colors.amber,
                size: 16,
              );
            }),
          ),
          const SizedBox(width: 8),
          Text(
            widget.review.rating.toString(),
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildFlightInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildInfoChip(
            widget.review.route,
            Colors.blue[50]!,
            Colors.blue[700]!,
          ),
          const SizedBox(width: 8),
          _buildInfoChip(
            widget.review.airline,
            Colors.green[50]!,
            Colors.green[700]!,
          ),
          const SizedBox(width: 8),
          _buildInfoChip(
            widget.review.flightClass,
            Colors.purple[50]!,
            Colors.purple[700]!,
          ),
          const SizedBox(width: 8),
          _buildInfoChip(
            widget.review.travelMonth,
            Colors.orange[50]!,
            Colors.orange[700]!,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String text, Color backgroundColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        widget.review.content,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black87,
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildImages() {
    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          widget.review.images.first,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[300],
              child: const Center(
                child: Icon(Icons.image, size: 50, color: Colors.grey),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                '${widget.review.likes} Like',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const Spacer(),
              Text(
                '${widget.review.comments} Comment',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isLiked = !_isLiked;
                    });
                    widget.onLike();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                        size: 18,
                        color: _isLiked ? Colors.blue : Colors.grey[600],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Like',
                        style: TextStyle(
                          fontSize: 14,
                          color: _isLiked ? Colors.blue : Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(width: 1, height: 20, color: Colors.grey[300]),
              Expanded(
                child: GestureDetector(
                  onTap: widget.onShare,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.share_outlined,
                        size: 18,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Share',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (widget.comments.isNotEmpty) ...[
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () {
                setState(() {
                  _showComments = !_showComments;
                });
              },
              child: Text(
                _showComments ? 'Hide Comments' : 'See More Comments',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blue[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildComments() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...widget.comments.map((comment) => _buildComment(comment)),
          const SizedBox(height: 12),
          _buildCommentInput(),
        ],
      ),
    );
  }

  Widget _buildComment(Comment comment) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 15,
            backgroundImage: NetworkImage(comment.authorAvatar),
            onBackgroundImageError: (exception, stackTrace) {},
            child: comment.authorAvatar.isEmpty
                ? const Icon(Icons.person, size: 16, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      comment.authorName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${comment.upvotes} Upvotes',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  comment.timeAgo,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 4),
                Text(
                  comment.content,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Handle upvote
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.thumb_up_outlined,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Upvote',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () {
                        // Handle reply
                      },
                      child: Row(
                        children: [
                          Icon(Icons.reply, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            'Reply',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentInput() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 15,
          backgroundImage: NetworkImage('https://via.placeholder.com/30'),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: const Row(
              children: [
                Expanded(
                  child: Text(
                    'Write Your Comment',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
                Icon(Icons.send, size: 20, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
