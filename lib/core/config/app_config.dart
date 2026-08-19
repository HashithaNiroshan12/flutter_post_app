enum AppEnvironment { dev, staging, production }

class AppConfig {
  AppConfig._();

  static const _envDefine = String.fromEnvironment('ENV', defaultValue: 'dev');
  static const _apiBaseUrlDefine = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://dummyjson.com',
  );
  static const _paginationLimitDefine = int.fromEnvironment(
    'PAGINATION_LIMIT',
    defaultValue: 10,
  );
  static const _searchDebounceMsDefine = int.fromEnvironment(
    'SEARCH_DEBOUNCE_MS',
    defaultValue: 300,
  );

  static AppEnvironment environment = _parse(_envDefine);
  static String apiBaseUrl = _apiBaseUrlDefine;
  static int paginationLimit = _paginationLimitDefine;
  static int searchDebounceMs = _searchDebounceMsDefine;

  static String get environmentName => environment.name.toUpperCase();

  static AppEnvironment _parse(String raw) => switch (raw) {
    'staging' => AppEnvironment.staging,
    'production' || 'prod' => AppEnvironment.production,
    _ => AppEnvironment.dev,
  };

  static void configure({
    AppEnvironment? environment,
    String? apiBaseUrl,
    int? paginationLimit,
    int? searchDebounceMs,
  }) {
    if (environment != null) AppConfig.environment = environment;
    if (apiBaseUrl != null) AppConfig.apiBaseUrl = apiBaseUrl;
    if (paginationLimit != null) AppConfig.paginationLimit = paginationLimit;
    if (searchDebounceMs != null) AppConfig.searchDebounceMs = searchDebounceMs;
  }
}