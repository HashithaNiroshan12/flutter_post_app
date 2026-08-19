import 'package:flutter_test/flutter_test.dart';
import 'package:posts_app/core/config/app_config.dart';

void main() {
  group('AppConfig', () {
    test('defaultEnvironment_isDev', () {
      expect(AppConfig.environment, AppEnvironment.dev);
      expect(AppConfig.environmentName, 'DEV');
    });

    test('configure_withStaging_setsEnvironmentAndValues', () {
      AppConfig.configure(
        environment: AppEnvironment.staging,
        apiBaseUrl: 'https://staging.example.com',
        paginationLimit: 15,
        searchDebounceMs: 400,
      );

      expect(AppConfig.environment, AppEnvironment.staging);
      expect(AppConfig.environmentName, 'STAGING');
      expect(AppConfig.apiBaseUrl, 'https://staging.example.com');
      expect(AppConfig.paginationLimit, 15);
      expect(AppConfig.searchDebounceMs, 400);
    });

    test('configure_withProduction_setsProduction', () {
      AppConfig.configure(environment: AppEnvironment.production);

      expect(AppConfig.environment, AppEnvironment.production);
      expect(AppConfig.environmentName, 'PRODUCTION');
    });

    test('configure_dev_explicitly_setsDevDefaults', () {
      AppConfig.configure(
        environment: AppEnvironment.dev,
        apiBaseUrl: 'https://dummyjson.com',
        paginationLimit: 10,
        searchDebounceMs: 300,
      );

      expect(AppConfig.environment, AppEnvironment.dev);
      expect(AppConfig.environmentName, 'DEV');
      expect(AppConfig.apiBaseUrl, 'https://dummyjson.com');
      expect(AppConfig.paginationLimit, 10);
      expect(AppConfig.searchDebounceMs, 300);
    });
  });
}