# fl_basic_accounting

[dart-badge]:
  https://img.shields.io/badge/SDK-^3.7.2-red?style=flat&logo=dart&logoColor=2cb8f7&labelColor=333333&color=01579b
[flutter-badge]:
  https://img.shields.io/badge/SDK-^3.29.2-red?style=flat&logo=flutter&logoColor=2cb8f7&labelColor=333333&color=01579b

![dart-badge] ![flutter-badge]

This application aims to assist users in recording and monitoring financial
conditions through a simple **Cash Flow** based accounting system. Suitable for
individuals, or small business owners who want to understand the flow of money
without the complexity of a full accounting system.

> ⚠️ In early development stage.  
> Features subject to change as needed.

## 🎯 Main Objective

- Record financial transactions efficiently.
- Generate daily, monthly, or annual financial reports automatically:
  - Cash Flow Statement
  - Profit and Loss Statement
  - Balance Sheet

## 🧱 Key Features

- ✍️ **Transaction Recording**  
  Record income and expenses. In order to be formed into financial reports, each
  record will have categories such as assets, liabilities, etc.

- 📊 **Automated Reports**  
  The application can display financial reports based on data from previous
  transaction records.

- 🗂️ **Project Based**  
  Want to create another financial reports for business or other purposes?
  Simply create a new project and the data will be separate from other projects.

## 💡 Development Plan

- [x] ~~Project Creation.~~

- [ ] Recording transactions on the project.

- [ ] Generation of financial reports from project transactions.

- [ ] Import/Export data with the help of spreadsheet files.

- [ ] If possible, integrate users' Google Drive (Spreadsheet) to share data
      across devices, so developers don't have to pay database fees 🤣.

## 💻 Developer Section

### Requirements

[fl-archive]: https://docs.flutter.dev/release/archive
[fvm]: https://fvm.app/documentation

- Install [Flutter SDK][fl-archive] with the same version as defined on
  [`pubspec.yaml`](pubspec.yaml) or [`.fvmrc`](.fvmrc) file.

  You may use [fvm] (Flutter Version Manager) for easy installation.

  ```sh
  fvm use prod
  ```

### Dependencies

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

### Setup

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

### Package Import Alias

[pubspec.yaml]: ./pubspec.yaml

This project modified its name in [pubspec.yaml] to `app`, so default package
import won't work.

```dart
// Do
import "package:app/main.dart";

// Instead of
import "package:fl_basic_accounting/main.dart";
```

### Project Structures

[clean-architecture]:
  https://medium.com/@DrunknCode/clean-architecture-simplified-and-in-depth-guide-026333c54454

This project will follow the [clean-architecture].

```txt
└── lib/
    ├── domain/ (repos/services abstraction, and data entities)
    ├── infrastructures/ (repos/services implementation, "data" layer stored here too)
    ├── use_cases/ (app logic)
    ├── interfaces/ (app UI/UX, also known as "presentation" layer)
    └── **/libs/ (Shared constants, utilities, etc. May defined on others sub folders)
```

### Git Conventions

[conventional-commits]: https://www.conventionalcommits.org
[release-please-action]: https://github.com/googleapis/release-please-action

We use [conventional-commits] to handle Git commit messages, and Github PR
titles.

#### Issue Title

```txt
<type>(<scopes(optional)>): <content>
```

Examples:

- `feat: add foo service`
- `bug: unresponsive bar page`

#### Commit Message / PR Title

```txt
<type>(<scopes(optional)>): <content> #<issue-number>
```

Examples:

- `feat: add foo abstraction #89`
- `fix: fix invalid behavior of bar method #82`

> Since [release-please-action] will need PR hash ref on commit msg, we won't
> recommend to do rebase merge on `main` branch.

#### Branch Name

```txt
<type>-<content>-#<issue-number>
```

Examples:

- `chore-update-docs-#26`
- `fix-unresponsive-foo-page-#75`
