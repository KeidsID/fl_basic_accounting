# fl_basic_accounting

[dart-badge]:
  https://img.shields.io/badge/SDK-^3.7.0-red?style=flat&logo=dart&logoColor=2cb8f7&labelColor=333333&color=01579b
[fl-badge]:
  https://img.shields.io/badge/SDK-^3.29.0-red?style=flat&logo=flutter&logoColor=2cb8f7&labelColor=333333&color=01579b

![Dart v3.7.0][dart-badge] ![Flutter v3.29.0][fl-badge]

Simple Cash Flow based accounting system. Suitable for individuals, or small
business owners who want to understand the flow of money without the complexity
of a full accounting system.

## Requirements

[fl-archive]: https://docs.flutter.dev/release/archive
[fvm]: https://fvm.app/documentation

- Install [Flutter SDK][fl-archive] with the same version as defined on
  [`pubspec.yaml`](pubspec.yaml) or [`.fvmrc`](.fvmrc) file.

  You may use [fvm] (Flutter Version Manager) for easy installation.

  ```sh
  fvm use prod
  ```

## Dependencies

Main packages that are used as foundation for this project.

[build_runner]: https://pub.dev/packages/build_runner
[injectable]: https://pub.dev/packages/injectable
[freezed]: https://pub.dev/packages/freezed
[go_router]: https://pub.dev/packages/go_router
[riverpod]: https://riverpod.dev

- [freezed] ~ Data class with less boilerplate syntax.
- [injectable] ~ Dependency injection framework.
- [go_router] ~ Web friendly routing.
- [riverpod] ~ State management.

Most of them need to generate its utilities with [build_runner].

## Setup

1. Install dependencies.

   ```sh
   flutter pub get
   ```

2. Intialize git hooks to validate commit messages.

   ```sh
   dart run husky install
   ```

3. Build project environment.

   ```sh
   dart run build_runner build -d # generate code utils
   ```

4. Now you're good to go!

   ```sh
   # Check connected devices
   flutter devices

   # Check available emulators
   flutter emulators

   # Run app
   flutter run -d <device-id>
   ```

## Package Import Alias

[pubspec.yaml]: ./pubspec.yaml

This project modified its name in [pubspec.yaml] to `app`, so default package
import won't work.

```dart
// Do
import "package:app/main.dart";

// Instead of
import "package:fl_basic_accounting/main.dart";
```

## Project Structures

[clean-architecture]:
  https://medium.com/@DrunknCode/clean-architecture-simplified-and-in-depth-guide-026333c54454

By default, this project follow the [clean-architecture], but you may modify it
to fit your needs since only `/interfaces/` layers example are provided.

```txt
└── lib/
    ├── domain/ (repos/services abstraction, and data entities)
    ├── infrastructures/ (repos/services implementation, "data" layer stored here too)
    ├── use_cases/ (app logic)
    └── interfaces/ (app UI/UX, also known as "presentation" layer)
```

[dicoding_story_fl]: https://github.com/KeidsID/dicoding_story_fl

If you want complete example of this structure, visit [dicoding_story_fl].

## Git Conventions

[conventional-commits]: https://www.conventionalcommits.org
[release-please-action]: https://github.com/googleapis/release-please-action

We use [conventional-commits] to handle Git commit messages, and Github PR
titles.

### Issue Title

```txt
<type>(<scopes(optional)>): <content>
```

Examples:

- `feat: add foo service`
- `bug: unresponsive bar page`

### Commit Message / PR Title

```txt
<type>(<scopes(optional)>): <content> #<issue-number>
```

Examples:

- `feat: add foo abstraction #89`
- `fix: fix invalid behavior of bar method #82`

> Since [release-please-action] will need PR hash ref on commit msg, we won't
> recommend to do rebase merge on `main` branch.

### Branch Name

```txt
<type>-<content>-#<issue-number>
```

Examples:

- `chore-update-docs-#26`
- `fix-unresponsive-foo-page-#75`
