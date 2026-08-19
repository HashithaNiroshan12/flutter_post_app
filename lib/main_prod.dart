import 'package:flutter/widgets.dart';

import 'app/app.dart';
import 'app/app_dependencies.dart';
import 'core/config/app_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig.configure(
    environment: AppEnvironment.production,
    apiBaseUrl: 'https://dummyjson.com',
    paginationLimit: 20,
    searchDebounceMs: 800,
  );
  final dependencies = await AppDependencies.create();
  runApp(PostsApp(dependencies: dependencies));
}
