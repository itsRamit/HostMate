<!-- HostMate — Copilot instructions for AI coding agents -->

This file contains concise, actionable guidance for AI coding agents working in the HostMate Flutter app.

High-level overview
- Flutter app (lib/) with dark custom theming in `lib/theme.dart` (AppColors, AppTextStyles, `appTheme`).
- State management uses Riverpod (legacy StateNotifierProvider). Example: `lib/provider/onboarding_provider.dart` exposes `onboardingProvider`.
- Networking is encapsulated in `lib/services/api_service.dart` using Dio; responses expect a nested shape: `data.data.experiences`.
- Models live in `lib/models/` (e.g., `Experience` in `lib/models/experience.dart`). UI widgets in `lib/widgets/` (e.g., `ExperienceCard`).

Key files to consult
- `lib/main.dart` — app entrypoint (root widget `MyApp`). Note: `home` is currently `null` in this branch; take care when running locally.
- `lib/theme.dart` — canonical color/text styles and `appTheme`.
- `lib/provider/onboarding_provider.dart` — canonical pattern for StateNotifier + OnboardingState + `copyWith`.
- `lib/services/api_service.dart` — single place for HTTP calls; staging URL used here.
- `lib/widgets/experience_card.dart` — shows UI conventions (CachedNetworkImage usage, grayscale overlay for unselected cards, AnimatedContainer transforms).

Project-specific conventions and patterns
- Riverpod (legacy) StateNotifier pattern — prefer `StateNotifier` + `StateNotifierProvider` and `copyWith` on immutable-like state classes. Do not auto-migrate to hooks or non-legacy Riverpod without confirmation.
- Theme values centralized in `lib/theme.dart`. Use `AppColors`, `AppTextStyles` and `appTheme` rather than ad-hoc color/text values.
- Network response shape: APIs return a Map under `data`, then `data['experiences']` — map code should handle missing keys safely (see `ApiService.fetchExperiences`).
- Image loading: `CachedNetworkImage` with local fallback `assets/placeholder.png`. Keep placeholder asset name consistent.

Build, run, and test notes (developer workflows)
- Install deps: `flutter pub get`
- Run app (choose device): `flutter run -d <deviceId>` from repo root.
- Run tests: `flutter test` (unit/widget tests under `test/`).
- Android/iOS: native folders present; use standard Flutter workflows (`flutter build apk`, `flutter build ios`). On Windows use the `windows/` runner if needed.
- If `main.dart`'s `home` is null, tests or runs may fail — set a valid widget while developing locally.

Integration points & external dependencies
- HTTP client: `dio` — configured ad-hoc in `ApiService`. The staging endpoint is hard-coded; update carefully when changing environments.
- Packages observed: `dio`, `cached_network_image`, `flutter_riverpod` (legacy). Check `pubspec.yaml` for exact versions before changes.

Testing & debugging hints
- Widget tests: `test/widget_test.dart` exists as starting point. Prefer small widgets with deterministic inputs.
- To debug network code, stub or inject a custom Dio instance into `ApiService` (the constructor supports an optional `Dio? dio`). Use this for unit tests.
- State tests: instantiate `OnboardingNotifier` directly and assert `state` changes via `toggleExperience`, `setExperienceText`, etc.

Small gotchas to avoid
- Don't assume `image_url` or `icon_url` are present — `Experience.fromJson` uses fallback empty strings.
- The app currently uses the legacy Riverpod import path: `package:flutter_riverpod/legacy.dart` — avoid blind refactors to the newer API without discussion.
- Theme and typography rely on the `SpaceGrotesk` font family; ensure fonts are preserved when changing text styles.

How to make safe changes (short checklist)
- Run `flutter pub get`.
- Update code and run `flutter analyze` / `flutter test` locally.
- Inject test doubles for `ApiService` by passing a mocked `Dio` instance.

If unsure, consult these files first: `lib/main.dart`, `lib/theme.dart`, `lib/provider/onboarding_provider.dart`, `lib/services/api_service.dart`, `lib/models/experience.dart`, `lib/widgets/experience_card.dart`.

If you want more detail (examples, tests, or CI integration), tell me which area to expand and I will update this file.
