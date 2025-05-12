import "package:drift/drift.dart";
import "package:drift_flutter/drift_flutter.dart";
import "package:flutter/foundation.dart";
import "package:injectable/injectable.dart";

import "package:app/domain/entities.dart";
import "database.steps.dart";
import "tables.dart";

part "database.g.dart";

/// The main database service for the app.
///
/// Backed by [drift](https://drift.simonbinder.eu/).
@lazySingleton
@DriftDatabase(
  tables: [
    Projects,
    ProjectTransactions,
    ProjectTransactionTags,
    ProjectTransactionTagRelations,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? _openConnection());

  @override
  int get schemaVersion => 2;

  /// When to do migrations?
  ///
  /// * Table schema changes (new, alter, or deletion).
  /// * Index changes.
  ///
  /// To do migrations, increment the [schemaVersion] and then run:
  ///
  /// ```bash
  /// dart run drift_dev make-migrations
  /// ```
  ///
  /// This will generate updated migration steps and tests, then you need to
  /// update [migration] property to pass the tests.
  ///
  /// Incase you need to do changes on the recent migration (no version change),
  /// delete the schema version at `drift_schemas/app_database` first before
  /// running the migration command. Just make sure to not delete previous
  /// version schema.
  ///
  /// To run the migration tests, do:
  ///
  /// ```bash
  /// flutter test ./test/drift/app_database/migration_test.dart
  /// ```
  ///
  /// https://drift.simonbinder.eu/Migrations/
  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: stepByStep(
      from1To2: (m, schema) async {
        await m.createTable(projectTransactions);
        await m.createTable(projectTransactionTags);
        await m.createTable(projectTransactionTagRelations);

        await m.createIndex(idxProjects);
        await m.createIndex(idxProjectTransactions);
        await m.createIndex(idxProjectTransactionTags);
      },
    ),
    beforeOpen: (details) async {
      if (details.wasCreated) {
        if (kDebugMode) {
          final m = createMigrator();

          for (var schema in allSchemaEntities.reversed) {
            await m.drop(schema);
          }
          await m.createAll();

          await _debugSeeds(this, details);
        }
      }

      await customStatement("PRAGMA foreign_keys = ON");
    },
  );

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

/// Seeds the database with initial data for debug purpose.
Future<void> _debugSeeds(AppDatabase db, OpeningDetails details) async {
  final isSeeded = (await (db.projects.select()..limit(1)).get()).isNotEmpty;

  if (isSeeded) return;

  db.transaction(() async {
    await db.projects.insertAll(
      [
        "Project A",
        "Project B",
        "Project C",
        "Project D",
        "Project E",
      ].map((e) => ProjectsCompanion.insert(name: e)),
    );

    final seededProjects = await db.projects.select().get();

    for (var project in seededProjects) {
      final dummyTransactions = _getDummyProjectTransactions(project.id);

      await db.projectTransactions.insertAll(
        dummyTransactions.map(
          (e) => ProjectTransactionModelX.fromEntity(e).toValidCompanion(),
        ),
      );
    }
  });
}

List<ProjectTransaction> _getDummyProjectTransactions(int projectId) {
  final now = DateTime.now().toUtc();

  if (projectId % 2 == 0) {
    return [
      ProjectTransaction(
        projectId: projectId,
        amount: 500,
        transactionType: ProjectTransactionType.equity,
        description: "Cash Deposit",
        transactionDate: now,
      ),
      ProjectTransaction(
        projectId: projectId,
        amount: 150,
        transactionType: ProjectTransactionType.asset,
        description: "Equipment Purchase",
        transactionDate: now.add(Duration(days: 1)),
      ),
      ProjectTransaction(
        projectId: projectId,
        amount: -200,
        transactionType: ProjectTransactionType.operation,
        description: "Office Supplies Expense",
        transactionDate: now.add(Duration(days: 1)),
      ),
      ProjectTransaction(
        projectId: projectId,
        amount: 300,
        transactionType: ProjectTransactionType.operation,
        description: "Service Revenue",
        transactionDate: now.add(Duration(days: 7)),
      ),
    ];
  }

  return [
    ProjectTransaction(
      projectId: projectId,
      amount: 1000,
      transactionType: ProjectTransactionType.liability,
      description: "Loan",
      transactionDate: now,
    ),
    ProjectTransaction(
      projectId: projectId,
      amount: -250,
      transactionType: ProjectTransactionType.operation,
      description: "Marketing Expense",
      transactionDate: now.add(Duration(days: 1)),
    ),
    ProjectTransaction(
      projectId: projectId,
      amount: -300,
      transactionType: ProjectTransactionType.asset,
      description: "Vehicle Purchase",
      transactionDate: now.add(Duration(days: 2)),
    ),
    ProjectTransaction(
      projectId: projectId,
      amount: 400,
      transactionType: ProjectTransactionType.operation,
      description: "Product Sales Revenue",
      transactionDate: now.add(Duration(days: 8)),
    ),
  ];
}
