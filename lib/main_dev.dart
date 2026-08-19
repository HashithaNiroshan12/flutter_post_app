import 'package:flutter/widgets.dart';

import 'app/app.dart';
import 'app/app_dependencies.dart';
import 'core/config/app_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig.configure(
    environment: AppEnvironment.dev,
    apiBaseUrl: 'https://dummyjson.com',
    paginationLimit: 10,
    searchDebounceMs: 300,
  );
  final dependencies = await AppDependencies.create();
  runApp(PostsApp(dependencies: dependencies));
}