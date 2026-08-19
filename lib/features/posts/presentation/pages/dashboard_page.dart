import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../auth/domain/entities/app_user.dart';
import '../../domain/entities/post.dart';
import '../../domain/repositories/posts_repository.dart';
import '../../domain/usecases/get_post_author_usecase.dart';
import '../../domain/usecases/get_post_comments_usecase.dart';
import '../../domain/usecases/get_post_detail_usecase.dart';
import '../bloc/post_detail_bloc.dart';
import '../bloc/post_detail_event.dart';
import '../bloc/posts_bloc.dart';
import '../bloc/posts_event.dart';
import '../bloc/posts_state.dart';
import '../widgets/featured_card.dart';
import '../widgets/post_error.dart';
import '../widgets/recent_card.dart';
import 'post_detail_page.dart';
import 'profile_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key, required this.user});

  final AppUser user;

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final _search = TextEditingController();
  final _scroll = ScrollController();
  int _tab = 0;
  late final GetPostAuthorUseCase _authorUseCase;
  late final GetPostCommentsUseCase _commentsUseCase;

  @override
  void initState() {
    super.initState();
    final postsRepository = context.read<PostsRepository>();
    _authorUseCase = GetPostAuthorUseCase(postsRepository);
    _commentsUseCase = GetPostCommentsUseCase(postsRepository);
    _scroll.addListener(() {
      if (_scroll.position.pixels > _scroll.position.maxScrollExtent - 240) {
        context.read<PostsBloc>().add(const PostsLoadMore());
      }
    });
  }

  @override
  void dispose() {
    _search.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _showSoon() => ScaffoldMessenger.of(
    context,
  ).showSnackBar(const SnackBar(content: Text('Coming soon')));

  @override
  Widget build(BuildContext context) => Scaffold(
    bottomNavigationBar: NavigationBar(
      backgroundColor: Colors.white,
      selectedIndex: _tab,
      indicatorColor: Colors.white,
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => TextStyle(
          color: states.contains(WidgetState.selected)
              ? const Color(0xFF2DC28D)
              : AppColors.secondary,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      onDestinationSelected: (value) {
        if (value == 4) {
          setState(() => _tab = value);
        } else if (value == 0) {
          setState(() => _tab = value);
        } else {
          _showSoon();
        }
      },
      destinations: [
        NavigationDestination(
          icon: SvgPicture.asset(
            'assets/svg/home_unselect.svg',
            width: 20,
            height: 20,
          ),
          selectedIcon: SvgPicture.asset(
            'assets/svg/home_select.svg',
            width: 20,
            height: 20,
          ),
          label: 'Home',
        ),
        NavigationDestination(
          icon: SvgPicture.asset('assets/svg/star.svg', width: 20, height: 20),
          label: 'Top Rate',
        ),
        NavigationDestination(
          icon: SvgPicture.asset('assets/svg/news.svg', width: 20, height: 20),
          label: 'News',
        ),
        NavigationDestination(
          icon: SvgPicture.asset(
            'assets/svg/messenger.svg',
            width: 20,
            height: 20,
          ),
          label: 'Chat',
        ),
        NavigationDestination(
          icon: SvgPicture.asset(
            'assets/svg/customers_unselect.svg',
            width: 20,
            height: 20,
          ),
          selectedIcon: SvgPicture.asset(
            'assets/svg/customers_select.svg',
            width: 20,
            height: 20,
          ),
          label: 'Profile',
        ),
      ],
    ),
    body: _tab == 4
        ? ProfilePage(
            user: widget.user,
            onBack: () => setState(() => _tab = 0),
            onUnavailable: _showSoon,
          )
        : SafeArea(
            child: BlocBuilder<PostsBloc, PostsState>(
              builder: (context, state) => RefreshIndicator(
                onRefresh: () async {
                  context.read<PostsBloc>().add(const PostsRefreshed());
                  await context.read<PostsBloc>().stream.firstWhere(
                    (s) => s.status != PostsStatus.loading,
                  );
                },
                child: CustomScrollView(
                  controller: _scroll,
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    _header(),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                        child: TextField(
                          controller: _search,
                          onChanged: (value) => context.read<PostsBloc>().add(
                            PostsSearchChanged(value),
                          ),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(200),
                              ),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(200),
                              ),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(200),
                              ),
                              borderSide: BorderSide(
                                color: AppColors.primary,
                                width: 1.5,
                              ),
                            ),
                            hintStyle: TextStyle(
                              fontSize: 12,
                              color: AppColors.secondary,
                              fontWeight: FontWeight.w300,
                              fontFamily: 'LexendDeca',
                            ),
                            hintText: 'Search posts ...',
                            prefixIcon: Icon(Icons.search),
                            contentPadding: EdgeInsets.symmetric(vertical: 0),
                          ),
                        ),
                      ),
                    ),
                    if (state.status == PostsStatus.loading)
                      const SliverFillRemaining(
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (state.status == PostsStatus.failure)
                      SliverFillRemaining(
                        child: PostError(
                          message: state.error ?? 'Unable to load posts',
                          onRetry: () => context.read<PostsBloc>().add(
                            const PostsLoaded(),
                          ),
                        ),
                      )
                    else if (state.posts.isEmpty)
                      const SliverFillRemaining(
                        child: Center(child: Text('No posts found.')),
                      )
                    else
                      ..._content(state),
                  ],
                ),
              ),
            ),
          ),
  );

  Widget _header() => SliverToBoxAdapter(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
      child: Row(
        children: [
          Text(
            _greeting(),
            style: appTheme().textTheme.headlineSmall?.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              fontFamily: 'LexendDeca',
            ),
          ),
          const Spacer(),
          CircleAvatar(
            backgroundColor: AppColors.primary,
            child: Text(
              widget.user.initials.isEmpty ? 'U' : widget.user.initials,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 14,
                fontFamily: 'LexendDeca',
              ),
            ),
          ),
        ],
      ),
    ),
  );

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) return 'Good Morning!';
    if (hour >= 12 && hour < 17) return 'Good Afternoon!';
    if (hour >= 17 && hour < 21) return 'Good Evening!';
    return 'Good Night!';
  }

  List<Widget> _content(PostsState state) {
    final searching = state.query.isNotEmpty;
    final featured = state.posts.take(5).toList();
    final recent = searching ? state.posts : state.posts.skip(5).toList();
    return [
      if (!searching)
        SliverToBoxAdapter(child: _sectionTitle('Featured Posts')),
      if (!searching)
        SliverToBoxAdapter(
          child: SizedBox(
            height: 260,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: featured.length,
              separatorBuilder: (_, _) => const SizedBox(width: 14),
              itemBuilder: (context, index) => FeaturedCard(
                post: featured[index],
                authorUseCase: _authorUseCase,
                onTap: () => _open(featured[index]),
              ),
            ),
          ),
        ),
      SliverToBoxAdapter(
        child: _sectionTitle(searching ? 'Search Results' : 'Recent Posts'),
      ),
      SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          if (index == recent.length) {
            return state.isLoadingMore
                ? const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : const SizedBox(height: 18);
          }
          final post = recent[index];
          return RecentCard(
            post: post,
            authorUseCase: _authorUseCase,
            commentsUseCase: _commentsUseCase,
            onTap: () => _open(post),
          );
        }, childCount: recent.length + 1),
      ),
    ];
  }

  Widget _sectionTitle(String title) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 26, 20, 12),
    child: Row(
      children: [
        Text(
          title,
          style: appTheme().textTheme.titleLarge?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            fontFamily: 'LexendDeca',
          ),
        ),
        const Spacer(),
        if (title == 'Featured Posts' || title == 'Recent Posts')
          const Text(
            'View All',
            style: TextStyle(
              color: AppColors.success,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              fontFamily: 'LexendDeca',
            ),
          ),
      ],
    ),
  );

  void _open(Post post) => Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => BlocProvider(
        create: (context) => PostDetailBloc(
          GetPostDetailUseCase(context.read<PostsRepository>()),
        )..add(PostDetailRequested(post.id)),
        child: const PostDetailPage(),
      ),
    ),
  );
}
