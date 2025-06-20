import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../routing/app_router.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../widgets/airline_banner.dart';
import '../widgets/review_card.dart';
import '../widgets/action_buttons.dart';
import '../widgets/search_bar.dart';
import '../../data/models/review_models.dart';
import '../../data/repositories/post_repository_impl.dart';
import '../bloc/post_bloc.dart';
import '../bloc/post_event.dart';
import '../bloc/post_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          PostBloc(PostRepositoryImpl())..add(const LoadPosts()),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      context.read<PostBloc>().add(LoadMorePosts());
    }
  }

  // Placeholder current user ID - in a real app, this would come from authentication state
  static const String _currentUserId = "685391a607a87fb45ddc4a5a";

  bool _canDeletePost(ReviewPost post) {
    // Check if the current user is the author of the post
    // In a real app, you'd get the current user ID from the auth state
    return post.authorInfo?.id == _currentUserId;
  }

  void _deletePost(BuildContext context, ReviewPost post) {
    context.read<PostBloc>().add(
      DeletePost(postId: post.id, postType: post.type),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(context),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<PostBloc>().add(RefreshPosts());
          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: BlocConsumer<PostBloc, PostState>(
          listener: (context, state) {
            if (state is PostSubmitted) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            } else if (state is PostSubmissionError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            } else if (state is PostError) {
              // Handle delete errors and other general errors
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is PostLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PostError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${state.message}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<PostBloc>().add(const LoadPosts()),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            } else if (state is PostLoaded || state is PostLoadingMore) {
              final posts = state is PostLoaded
                  ? state.posts
                  : (state as PostLoadingMore).posts;

              return SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    const ActionButtons(),
                    const SizedBox(height: 16),
                    const CustomSearchBar(),
                    const SizedBox(height: 16),
                    const AirlineBanner(),
                    const SizedBox(height: 24),
                    ...posts.map(
                      (post) => Column(
                        children: [
                          ReviewCard(
                            review: post,
                            comments: post.postComments
                                .map(
                                  (pc) => Comment(
                                    id: pc.id,
                                    authorName: pc.authorName,
                                    authorAvatar: pc.authorAvatar,
                                    content: pc.content,
                                    timeAgo: pc.timeAgo,
                                    upvotes: pc.upvotes,
                                  ),
                                )
                                .toList(),
                            onLike: () {},
                            onShare: () {},
                            onComment: () {},
                            canDelete: _canDeletePost(post),
                            onDelete: () => _deletePost(context, post),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                    if (state is PostLoadingMore)
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator(),
                      ),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
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
        Container(
          margin: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey[300]!),
            image: const DecorationImage(
              image: CachedNetworkImageProvider(
                'https://thispersondoesnotexist.com/',
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: IconButton(
            iconSize: 28,
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {
              // Handle menu actions
              _showProfileMenu(context);
            },
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
}
