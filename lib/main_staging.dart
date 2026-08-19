import 'package:flutter/widgets.dart';

import 'app/app.dart';
import 'app/app_dependencies.dart';
import 'core/config/app_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig.configure(
    environment: AppEnvironment.staging,
    apiBaseUrl: 'https://dummyjson.com',
    paginationLimit: 15,
    searchDebounceMs: 500,
  );
  final dependencies = await AppDependencies.create();
  runApp(PostsApp(dependencies: dependencies));
}
