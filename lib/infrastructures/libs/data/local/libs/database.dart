import "package:drift/drift.dart";
import "package:drift_flutter/drift_flutter.dart";
import "package:injectable/injectable.dart";

import "tables.dart";

part "database.g.dart";

@lazySingleton
@DriftDatabase(tables: [Projects])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: "app_database",
      native: const DriftNativeOptions(),
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse("sqlite3.wasm"),
        driftWorker: Uri.parse("drift_worker.dart.js"),
      ),
    );
  }
}
