import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/theme/app_theme.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/domain/usecases/login_usecase.dart';
import '../features/auth/domain/usecases/logout_usecase.dart';
import '../features/auth/domain/usecases/restore_session_usecase.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/auth/presentation/bloc/auth_event.dart';
import '../features/auth/presentation/bloc/auth_state.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/posts/domain/repositories/posts_repository.dart';
import '../features/posts/domain/usecases/fetch_posts_usecase.dart';
import '../features/posts/presentation/bloc/posts_bloc.dart';
import '../features/posts/presentation/bloc/posts_event.dart';
import '../features/posts/presentation/pages/dashboard_page.dart';
import 'app_dependencies.dart';

class PostsApp extends StatelessWidget {
  const PostsApp({super.key, required this.dependencies});

  final AppDependencies dependencies;

  @override
  Widget build(BuildContext context) => MultiRepositoryProvider(
    providers: [
      RepositoryProvider<AuthRepository>.value(
        value: dependencies.authRepository,
      ),
      RepositoryProvider<PostsRepository>.value(
        value: dependencies.postsRepository,
      ),
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NewsBay',
      theme: appTheme(),
      home: BlocProvider(
        create: (_) => AuthBloc(
          LoginUseCase(dependencies.authRepository),
          RestoreSessionUseCase(dependencies.authRepository),
          LogoutUseCase(dependencies.authRepository),
        )..add(const AuthStarted()),
        child: const AuthGate(),
      ),
    ),
  );
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});
  @override
  Widget build(BuildContext context) => BlocBuilder<AuthBloc, AuthState>(
    builder: (context, state) {
      if (state.status == AuthStatus.checking) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }
      if (state.status == AuthStatus.authenticated) {
        return BlocProvider(
          create: (context) => PostsBloc(
            FetchPostsUseCase(context.read<PostsRepository>()),
          )..add(const PostsLoaded()),
          child: DashboardPage(user: state.user!),
        );
      }
      return const LoginPage();
    },
  );
}