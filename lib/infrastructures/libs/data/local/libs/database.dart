import "package:drift/drift.dart";
import "package:drift_flutter/drift_flutter.dart";
import "package:flutter/foundation.dart";
import "package:injectable/injectable.dart";

import "package:app/domain/entities.dart";
import "package:app/libs/extensions.dart";

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
  /// Create [AppDatabase] instance.
  AppDatabase([QueryExecutor? e]) : super(e ?? _openConnection());

  /// Create [AppDatabase] instance with [driftDatabase].
  @factoryMethod
  AppDatabase.create() : super(_openConnection());

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

          await _debugSeeds();
        }
      }

      await customStatement("PRAGMA foreign_keys = ON");
    },
  );

  /// Seeds the database with initial data for debug purpose.
  Future<void> _debugSeeds() async {
    final isSeeded = (await (projects.select()..limit(1)).get()).isNotEmpty;

    if (isSeeded) return;

    debugPrint("[AppDatabase] ~ Seeding dummy data into database");

    await transaction(() async {
      await projects.insertAll(
        [
          "Project A",
          "Project B",
          "Project C",
          "Project D",
          "Project E",
        ].map((e) => ProjectsCompanion.insert(name: e)),
      );

      final seededProjects = await projects.select().get();

      for (var project in seededProjects) {
        final dummyTransactions = _getDummyProjectTransactions(project.id);

        await projectTransactions.insertAll(
          dummyTransactions.map(
            (e) => ProjectTransactionModelX.fromEntity(e).toValidCompanion(),
          ),
        );
      }
    });

    debugPrint("[AppDatabase] ~ Dummy data seeded");
  }
}

List<ProjectTransaction> _getDummyProjectTransactions(int projectId) {
  final now = DateTime.now().toUtcMidnight();
  final last30DaysAgo = now.subtract(Duration(days: 30)).toMidnight();

  return [
    ProjectTransaction(
      projectId: projectId,
      amount: 500,
      transactionType: ProjectTransactionType.equity,
      description: "Cash Deposit",
      transactionDate: last30DaysAgo,
    ),
    ProjectTransaction(
      projectId: projectId,
      amount: 150,
      transactionType: ProjectTransactionType.asset,
      description: "Computer Equipment Purchase",
      transactionDate: last30DaysAgo.add(Duration(days: 1)),
    ),
    ProjectTransaction(
      projectId: projectId,
      amount: -200,
      transactionType: ProjectTransactionType.operation,
      description: "Monthly Office Supplies Expense",
      transactionDate: last30DaysAgo.add(Duration(days: 1)),
    ),
    ProjectTransaction(
      projectId: projectId,
      amount: 300,
      transactionType: ProjectTransactionType.operation,
      description: "Consulting Service Revenue",
      transactionDate: last30DaysAgo.add(Duration(days: 6)),
    ),
    ProjectTransaction(
      projectId: projectId,
      amount: 1000,
      transactionType: ProjectTransactionType.equity,
      description: "Additional Investor Funding",
      transactionDate: last30DaysAgo.add(Duration(days: 8)),
    ),
    ProjectTransaction(
      projectId: projectId,
      amount: -50,
      transactionType: ProjectTransactionType.operation,
      description: "Utility Bill Payment",
      transactionDate: last30DaysAgo.add(Duration(days: 10)),
    ),
    ProjectTransaction(
      projectId: projectId,
      amount: 750,
      transactionType: ProjectTransactionType.asset,
      description: "Vehicle Acquisition",
      transactionDate: last30DaysAgo.add(Duration(days: 12)),
    ),
    ProjectTransaction(
      projectId: projectId,
      amount: -120,
      transactionType: ProjectTransactionType.operation,
      description: "Marketing Campaign Expense",
      transactionDate: last30DaysAgo.add(Duration(days: 15)),
    ),
    ProjectTransaction(
      projectId: projectId,
      amount: 600,
      transactionType: ProjectTransactionType.operation,
      description: "Product Sales Revenue",
      transactionDate: last30DaysAgo.add(Duration(days: 18)),
    ),
    ProjectTransaction(
      projectId: projectId,
      amount: -300,
      transactionType: ProjectTransactionType.equity,
      description: "Owner's Drawing",
      transactionDate: last30DaysAgo.add(Duration(days: 20)),
    ),
    ProjectTransaction(
      projectId: projectId,
      amount: 250,
      transactionType: ProjectTransactionType.operation,
      description: "Website Development Service",
      transactionDate: last30DaysAgo.add(Duration(days: 22)),
    ),
    ProjectTransaction(
      projectId: projectId,
      amount: -80,
      transactionType: ProjectTransactionType.operation,
      description: "Travel Expense",
      transactionDate: last30DaysAgo.add(Duration(days: 25)),
    ),
    ProjectTransaction(
      projectId: projectId,
      amount: 400,
      transactionType: ProjectTransactionType.liability,
      description: "Loan from Bank",
      transactionDate: last30DaysAgo.add(Duration(days: 28)),
    ),
    ProjectTransaction(
      projectId: projectId,
      amount: -100,
      transactionType: ProjectTransactionType.operation,
      description: "Software Subscription Fee",
      transactionDate: last30DaysAgo.add(Duration(days: 30)),
    ),
  ];
}
