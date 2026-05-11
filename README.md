# Cinephile

**Cinephile** is a Flutter application for browsing movies and TV series. It talks to [The Movie Database (TMDB)](https://www.themoviedb.org/) and stores catalog data locally so lists stay usable offline after sync.

If you are **reviewing this repository for hiring**: the sections **What this project demonstrates** and **Tech stack** below summarize what to look for in the code. The rest is for anyone cloning and running the app.

---

## What this project demonstrates

- **Feature-first structure** — code is grouped by product area (`movies`, `tv_series`, `root`) with clear separation between UI, domain logic, and data.
- **Predictable state management** — `flutter_bloc` (cubits) for screens and catalog flows.
- **Layered data access** — remote API + local SQLite persistence (DAOs, schemas), with mock JSON fixtures for tests and development without a key.
- **Shared “core” module** — networking, database bootstrap, preferences (including secure storage), theme, localization, and small reusable widgets live under `lib/core/` so features stay focused.
- **Typed configuration** — API base URL and credentials are supplied at build time via `--dart-define`, not hard-coded secrets in source.
- **Automated tests** — `flutter test` covers data sources, domain rules, and related behavior.

Together, this reads as **production-style Flutter**: not a single-screen demo, but an app-shaped layout with room to grow.

## Tech stack

| Area | Choice |
|------|--------|
| UI framework | Flutter |
| Language | Dart (SDK ^3.11) |
| State | flutter_bloc |
| HTTP | dio |
| Local database | sqflite |
| Secure preferences | flutter_secure_storage |
| i18n | flutter_localizations + generated l10n (`l10n.yaml`) |
| Theming | Material + app theme (`theme/`) |

## Architecture (short)

- **`lib/features/`** — product features. Typical shape: `presentation/` (pages, cubits, widgets), `domain/` (entities, repositories, use cases), `data/` (DTOs, mappers, local + remote sources, repository implementations).
- **`lib/core/`** — cross-cutting infrastructure (e.g. `NetworkClient`, `DatabaseManager`, locale/theme cubits and repositories, shared DTO helpers where appropriate).
- **`assets/mocks/`** — static JSON used by mock remote data sources.

## Requirements

- [Flutter](https://docs.flutter.dev/get-started/install) (stable recommended).
- Dart **^3.11** (see `environment` in `pubspec.yaml`).

## Clone and run

```bash
git clone <repository-url>
cd cinephileapp
flutter pub get
flutter gen-l10n
flutter run
```

To hit the **live TMDB API**, pass a read token at run time (see Configuration). Without it, you can still explore flows that use **mock** remote data where implemented.

## Configuration

Values are read with [`String.fromEnvironment`](https://api.flutter.dev/flutter/dart-core/String/String.fromEnvironment.html) in `lib/core/config/env_config.dart`:

| `dart-define` | Role | If omitted |
|---------------|------|------------|
| `APP_ENV` | `dev` / `staging` / `prod` label | defaults to `dev` |
| `API_BASE_URL` | REST base URL | defaults to TMDB v3 base URL |
| `TMDB_BEARER_TOKEN` | TMDB v4 read access token | empty string (live calls need a real token) |

Example:

```bash
flutter run --dart-define=TMDB_BEARER_TOKEN=<your-token>
```

**Do not commit real tokens.** Use your machine’s shell profile, IDE run configuration, or CI secrets only.

## Tests

```bash
flutter test
```

## License

Add your license here (e.g. MIT, Apache-2.0) or state that the repository is proprietary.
