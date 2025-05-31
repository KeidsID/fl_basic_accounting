import "package:drift/drift.dart";
import "package:injectable/injectable.dart";

import "package:app/domain/entities.dart";

import "../libs/database.dart";
import "../libs/tables.dart";

part "projects_local_data.g.dart";

typedef _ReadQueryWhereFilter =
    Expression<bool> Function($ProjectsTable p, $ProjectTransactionsTable pt);

@lazySingleton
@DriftAccessor(tables: [Projects, ProjectTransactions])
class ProjectsLocalData extends DatabaseAccessor<AppDatabase>
    with _$ProjectsLocalDataMixin {
  ProjectsLocalData(super.db);

  Future<Project> create(Project entity) async {
    final result = await projects.insertReturning(
      ProjectModelX.fromEntity(entity).toValidCompanion(),
    );

    return result.toEntity();
  }

  /// [projects] read with [projectTransactions] join.
  Selectable<Project> _readQuery({
    _ReadQueryWhereFilter? whereFilter,
    bool includeTotalCash = true,
  }) {
    final p = alias(projects, "p");
    final pt = alias(projectTransactions, "pt");

    if (!includeTotalCash) {
      final query = p.select();
      if (whereFilter != null) query.where((p) => whereFilter(p, pt));

      return query.map((row) => row.toEntity());
    }

    final query = p.select().join([
      leftOuterJoin(pt, pt.projectId.equalsExp(p.id)),
    ]);

    final totalCashInExp =
        CaseWhenExpression(
          cases: [CaseWhen(pt.amount.isBiggerThanValue(0.0), then: pt.amount)],
          orElse: Variable(0.0),
        ).sum();

    final totalCashOutExp =
        CaseWhenExpression(
          cases: [CaseWhen(pt.amount.isSmallerThanValue(0.0), then: pt.amount)],
          orElse: Variable(0.0),
        ).sum();

    query.addColumns([totalCashInExp, totalCashOutExp]);
    query.groupBy([p.id]);

    if (whereFilter != null) {
      query.where(whereFilter(p, pt));
    }

    return query.map((row) {
      final project = row.readTable(p).toEntity();

      final totalCashIn = row.read(totalCashInExp)!;
      final totalCashOut = row.read(totalCashOutExp)!;

      return project.copyWith(
        totalCashIn: totalCashIn,
        totalCashOut: totalCashOut,
      );
    });
  }

  Selectable<Project> readAll({bool includeTotalCash = true}) {
    return _readQuery(includeTotalCash: includeTotalCash);
  }

  Future<Project?> readById(int id, {bool includeTotalCash = true}) async {
    return _readQuery(
      whereFilter: (projects, _) => projects.id.equals(id),
      includeTotalCash: includeTotalCash,
    ).getSingleOrNull();
  }

  Future<Project?> updateProject(Project updatedEntity) async {
    final now = DateTime.now().toUtc();

    final updateQuery = projects.update();
    updateQuery.where((p) => p.id.equals(updatedEntity.id));

    final results = await updateQuery.writeReturning(
      ProjectModelX.fromEntity(updatedEntity).toValidCompanion(updatedAt: now),
    );

    return results.firstOrNull?.toEntity();
  }

  Future<Project?> deleteById(int id) async {
    final deleteQuery = projects.delete();
    deleteQuery.where((p) => p.id.equals(id));

    final results = await deleteQuery.goAndReturn();

    return results.firstOrNull?.toEntity();
  }
}
