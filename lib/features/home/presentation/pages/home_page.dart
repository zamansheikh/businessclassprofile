import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../routing/app_router.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../widgets/airline_banner.dart';
import '../widgets/review_card.dart';
import '../widgets/action_buttons.dart';
import '../widgets/search_bar.dart';
import '../../data/models/review_models.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeView();
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final List<ReviewPost> _mockReviews = [
    ReviewPost(
      id: '1',
      authorName: 'Dianne Russell',
      authorAvatar: 'https://thispersondoesnotexist.com/',
      timeAgo: '1 day ago',
      rating: 5.0,
      route: 'LHR - DEL',
      airline: 'Air India',
      flightClass: 'Business Class',
      travelMonth: 'July 2023',
      content:
          'Stay tuned for a smoother, more convenient experience right at your fingertips, a smoother, more convenient a smoother, more convenient other, more convenient experience right at your',
      images: ['https://picsum.photos/300/200?random=1'],
      likes: 30,
      comments: 20,
      isLiked: false,
    ),
    ReviewPost(
      id: '2',
      authorName: 'John Smith',
      authorAvatar: 'https://thispersondoesnotexist.com/',
      timeAgo: '2 hours ago',
      rating: 4.5,
      route: 'JFK - LAX',
      airline: 'American Airlines',
      flightClass: 'First Class',
      travelMonth: 'August 2023',
      content:
          'Amazing flight experience with excellent service and comfortable seating. The cabin crew was very professional and attentive throughout the journey.',
      images: [
        'https://picsum.photos/300/200?random=2',
        'https://picsum.photos/300/200?random=3',
      ],
      likes: 45,
      comments: 12,
      isLiked: true,
    ),
    ReviewPost(
      id: '3',
      authorName: 'Sarah Johnson',
      authorAvatar: 'https://thispersondoesnotexist.com/',
      timeAgo: '5 hours ago',
      rating: 4.0,
      route: 'DXB - SIN',
      airline: 'Emirates',
      flightClass: 'Business Class',
      travelMonth: 'September 2023',
      content:
          'Great entertainment system and delicious meals. The only downside was a slight delay, but overall a pleasant experience with Emirates.',
      images: [
        'https://picsum.photos/300/200?random=4',
        'https://picsum.photos/300/200?random=5',
        'https://picsum.photos/300/200?random=6',
        'https://picsum.photos/300/200?random=7',
        'https://picsum.photos/300/200?random=8',
      ],
      likes: 67,
      comments: 28,
      isLiked: false,
    ),
    ReviewPost(
      id: '4',
      authorName: 'Michael Chen',
      authorAvatar: 'https://thispersondoesnotexist.com/',
      timeAgo: '1 week ago',
      rating: 3.5,
      route: 'NRT - SYD',
      airline: 'Japan Airlines',
      flightClass: 'Premium Economy',
      travelMonth: 'June 2023',
      content:
          'Decent flight with good legroom in premium economy. Food was okay but could be better. Service was polite but not exceptional.',
      images: [
        'https://picsum.photos/300/200?random=9',
        'https://picsum.photos/300/200?random=10',
        'https://picsum.photos/300/200?random=11',
      ],
      likes: 23,
      comments: 8,
      isLiked: false,
    ),
  ];

  final List<Comment> _mockComments = [
    Comment(
      id: '1',
      authorName: 'Darron Levesque',
      authorAvatar: 'https://thispersondoesnotexist.com/',
      content:
          'Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis',
      timeAgo: '3 min ago',
      upvotes: 5,
    ),
    Comment(
      id: '2',
      authorName: 'Darron Levesque',
      authorAvatar: 'https://thispersondoesnotexist.com/',
      content:
          'Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis',
      timeAgo: '3 min ago',
      upvotes: 5,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  const ActionButtons(),
                  const SizedBox(height: 16),
                  const CustomSearchBar(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const AirlineBanner(),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _mockReviews.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                return ReviewCard(
                  review: _mockReviews[index],
                  comments: _mockComments,
                  onLike: () => _onLike(_mockReviews[index].id),
                  onShare: () => _onShare(_mockReviews[index].id),
                  onComment: () => _onComment(_mockReviews[index].id),
                );
              },
            ),
            const SizedBox(height: 100), // Bottom padding
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: const Text(
        'Airline Review',
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        Stack(
          children: [
            IconButton(
              icon: const Icon(
                Icons.notifications_outlined,
                color: Colors.black,
              ),
              onPressed: () {
                // Handle notifications
              },
            ),
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                child: const Text(
                  '2',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            _showProfileMenu(context);
          },
          child: Container(
            margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey[300]!),
              image: const DecorationImage(
                image: NetworkImage('https://thispersondoesnotexist.com/'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showProfileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                context.push(AppRoutes.settings);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sign Out'),
              onTap: () {
                Navigator.pop(context);
                context.read<AuthBloc>().add(const SignOutRequested());
                context.go(AppRoutes.signIn);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _onLike(String reviewId) {
    // Handle like functionality
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Liked!')));
  }

  void _onShare(String reviewId) {
    // Handle share functionality
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Shared!')));
  }

  void _onComment(String reviewId) {
    // Handle comment functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Comment feature will be implemented!')),
    );
  }
}
