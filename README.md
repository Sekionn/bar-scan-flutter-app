# Barscan App

Flutter app for scanning store barcodes on Android and iOS, storing unsynced
scan rows locally, and syncing them to a server-owned message queue endpoint.

## Project Structure Rules

This app follows Flutter's recommended separation of concerns:

- `lib/main.dart` is only the entry point. Keep app setup in `lib/app/`.
- `lib/app/` contains root app composition, theme, and top-level dependency
  injection.
- `lib/features/<feature>/` contains user-facing screens for one feature.
- `lib/features/<feature>/widgets/` contains widgets only used by that feature.
- `lib/ui/core/` contains shared UI used across features, such as navigation.
- `lib/data/models/` contains plain data/domain objects.
- `lib/data/repositories/` contains app-facing data access APIs and business
  logic. UI should depend on repositories, not database/API services directly.
- `lib/data/services/` contains concrete external integrations, such as SQLite,
  HTTP APIs, platform plugins, or message queue adapters.
- `lib/utils/` contains small pure helpers. Do not put feature or business logic
  here.

## Dependency Direction

Keep dependencies flowing inward through stable boundaries:

- Features can import repositories, models, shared UI, and utils.
- Repositories can import models and services.
- Services can import models and third-party packages.
- Data code must not import feature screens or widgets.
- Shared UI must not depend on a specific feature unless it is explicitly a
  navigation component for the app shell.

## File Size Rule

Prefer one primary class per file. Small private helper widgets may live beside
their parent screen, but once a widget is reused or becomes non-trivial, move it
into a dedicated file.

## Running

Resolve dependencies:

```powershell
C:\Users\Sjknu\flutter-sdk\flutter\bin\flutter.bat pub get
```

Run the app:

```powershell
C:\Users\Sjknu\flutter-sdk\flutter\bin\flutter.bat run
```

Run with the sync endpoint configured:

```powershell
C:\Users\Sjknu\flutter-sdk\flutter\bin\flutter.bat run --dart-define=MESSAGE_QUEUE_ENDPOINT=https://your-server.example/queue
```

## Verification

Before handing off changes, run:

```powershell
C:\Users\Sjknu\flutter-sdk\flutter\bin\dart.bat format lib test
C:\Users\Sjknu\flutter-sdk\flutter\bin\flutter.bat analyze
C:\Users\Sjknu\flutter-sdk\flutter\bin\flutter.bat test
```
