# NewsBay Posts App

A Flutter posts app backed by the [DummyJSON](https://dummyjson.com) API, built with Clean Architecture, `flutter_bloc`, `Dio`, and `SharedPreferences`.

## Prerequisites

- Flutter SDK (stable channel) 3.44.0
- An Android device/emulator, Windows desktop, or Chrome

## Setup

```bash
flutter pub get
```

## Run

Each environment has its own entry point which sets its defaults at startup. `--dart-define` values override the entry-point defaults.

**Dev**
```bash
flutter run -t lib/main_dev.dart
```

**Staging**
```bash
flutter run -t lib/main_staging.dart
```

**Prod**
```bash
flutter run -t lib/main_prod.dart
```

With explicit overrides:
```bash
flutter run -t lib/main_dev.dart --dart-define=ENV=dev --dart-define=API_BASE_URL=https://dummyjson.com --dart-define=PAGINATION_LIMIT=10 --dart-define=SEARCH_DEBOUNCE_MS=300
```

| Config | Dev | Staging | Prod |

| API base URL | `https://dummyjson.com` | `https://dummyjson.com` | `https://dummyjson.com` |
| Pagination limit | 10 | 15 | 20 |
| Search debounce | 300ms | 500ms | 800ms |

The active environment is shown in the Profile tab (e.g. `Environment: DEV`).

## Demo credentials

DummyJSON is a public mock API. To log in, use any of its demo accounts, for example:

- Username: `emilys`
- Password: `emilyspass`

These are **public API test credentials** — the app does not hardcode or store any secrets. The auth token returned by DummyJSON is stored locally only via `SharedPreferences` (key `access_token`) and is cleared on logout.

## Architecture

- `core/` — network client (`ApiClient`), error types, app config, utils
- `features/auth/` + `features/posts/` — Clean Architecture layers: `data/` (datasources, models, repository impls) → `domain/` (entities, repository contracts, usecases) → `presentation/` (Blocs, pages, widgets)
- Dependencies are constructor-injected and composed once in `lib/app/app_dependencies.dart`; `PostsApp` receives them via `AppDependencies`

## Tests

```bash
flutter analyze
flutter test
flutter test --coverage
```

Coverage report is written to `coverage/lcov.info` (currently ~90% line coverage).
