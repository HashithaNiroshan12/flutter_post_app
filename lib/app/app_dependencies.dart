import 'package:shared_preferences/shared_preferences.dart';

import '../core/network/api_client.dart';
import '../features/auth/data/datasources/local/auth_local_data_source.dart';
import '../features/auth/data/datasources/remote/auth_remote_data_source.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/posts/data/datasources/remote/posts_remote_data_source.dart';
import '../features/posts/data/repositories/posts_repository_impl.dart';
import '../features/posts/domain/repositories/posts_repository.dart';

class AppDependencies {
  final AuthRepository authRepository;
  final PostsRepository postsRepository;

  AppDependencies._({
    required this.authRepository,
    required this.postsRepository,
  });

  static Future<AppDependencies> create() async {
    final preferences = await SharedPreferences.getInstance();

    final client = ApiClient();

    return AppDependencies._(
      authRepository: AuthRepositoryImpl(
        DioAuthRemoteDataSource(client),
        SharedPreferencesAuthLocalDataSource(preferences),
      ),
      postsRepository: PostsRepositoryImpl(DioPostsRemoteDataSource(client)),
    );
  }
}
