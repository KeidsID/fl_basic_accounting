import "package:drift/drift.dart";
import "package:injectable/injectable.dart";

import "package:app/domain/entities.dart";
import "../libs/database.dart";
import "../libs/extensions.dart";
import "../libs/tables.dart";

part "project_transactions_local_data.g.dart";

typedef _ReadQueryWhereFilter =
    Expression<bool> Function($ProjectTransactionsTable pt);

@lazySingleton
@DriftAccessor(
  tables: [
    ProjectTransactions,
    ProjectTransactionTags,
    ProjectTransactionTagRelations,
  ],
)
class ProjectTransactionsLocalData extends DatabaseAccessor<AppDatabase>
    with _$ProjectTransactionsLocalDataMixin {
  ProjectTransactionsLocalData(super.db);

  Future<ProjectTransaction> create(ProjectTransaction entity) async {
    final result = await projectTransactions.insertReturning(
      ProjectTransactionModelX.fromEntity(entity).toValidCompanion(),
    );

    return result.toEntity();
  }

  /// [projectTransactions] read with [projectTransactionTags] MtM relation via
  /// [projectTransactionTagRelations].
  ({
    Future<List<ProjectTransaction>> Function() fetch,
    Stream<List<ProjectTransaction>> Function() watch,
  })
  _readQuery({_ReadQueryWhereFilter? whereFilter}) {
    final transactionsQuery = projectTransactions.select();
    if (whereFilter != null) transactionsQuery.where(whereFilter);
    transactionsQuery.orderBy([(t) => OrderingTerm.asc(t.transactionDate)]);

    final mappedQuery = transactionsQuery.map((row) => row.toEntity());

    return (
      fetch: () async {
        final transactions = await mappedQuery.get();

        return _fetchTransactionsTags(transactions);
      },
      watch: () {
        return mappedQuery.watch().asyncMap((transactions) async {
          return _fetchTransactionsTags(transactions);
        });
      },
    );
  }

  Future<List<ProjectTransaction>> _fetchTransactionsTags(
    List<ProjectTransaction> transactions,
  ) async {
    if (transactions.isEmpty) return transactions;

    final ptt = alias(projectTransactionTags, "ptt");
    final pttr = alias(projectTransactionTagRelations, "pttr");

    final transactionIds = transactions.map((e) => e.id).toList();

    final tagRelationsQuery = pttr.select().join([
      innerJoin(ptt, ptt.id.equalsExp(pttr.tagId)),
    ]);
    tagRelationsQuery.where(pttr.transactionId.isIn(transactionIds));

    final tagRelations =
        await tagRelationsQuery.map((row) {
          final transactionId = row.readTable(pttr).transactionId;
          final tagEntity = row.readTable(ptt).toEntity();

          return (transactionId: transactionId, tagEntity: tagEntity);
        }).get();

    return transactions.map((transaction) {
      if (tagRelations.isEmpty) return transaction;

      final tags =
          tagRelations
              .where((e) => e.transactionId == transaction.id)
              .map((e) => e.tagEntity)
              .toList();

      return transaction.copyWith(tags: tags);
    }).toList();
  }

  Stream<List<ProjectTransaction>> readAll({
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return _readQuery(
      whereFilter: (pt) {
        return pt.transactionDate.isInRangeOf(startDate, endDate);
      },
    ).watch();
  }

  Future<ProjectTransaction?> readById(
    int id, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final results =
        await _readQuery(
          whereFilter: (pt) {
            return pt.id.equals(id) &
                pt.transactionDate.isInRangeOf(startDate, endDate);
          },
        ).fetch();

    return results.firstOrNull;
  }

  Stream<List<ProjectTransaction>> readAllByProjectId(
    int projectId, {
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return _readQuery(
      whereFilter: (pt) {
        return pt.projectId.equals(projectId) &
            pt.transactionDate.isInRangeOf(startDate, endDate);
      },
    ).watch();
  }

  Future<({double cashIn, double cashOut})> getProjectTotalCash(
    int projectId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final pt = alias(projectTransactions, "pt");
    final query = pt.select();
    query.where((pt) {
      return pt.projectId.equals(projectId) &
          pt.transactionDate.isInRangeOf(startDate, endDate);
    });

    final cashInExp =
        CaseWhenExpression(
          cases: [CaseWhen(pt.amount.isBiggerThanValue(0.0), then: pt.amount)],
          orElse: Variable(0.0),
        ).sum();
    final cashOutExp =
        CaseWhenExpression(
          cases: [CaseWhen(pt.amount.isSmallerThanValue(0.0), then: pt.amount)],
          orElse: Variable(0.0),
        ).sum();

    final queryWithCashTotal = query.addColumns([cashInExp, cashOutExp]);

    return queryWithCashTotal.map((row) {
      final cashIn = row.read(cashInExp) ?? 0.0;
      final cashOut = row.read(cashOutExp) ?? 0.0;

      return (cashIn: cashIn, cashOut: cashOut);
    }).getSingle();
  }

  Future<ProjectTransaction?> updateProjectTransaction(
    ProjectTransaction updatedEntity,
  ) async {
    final now = DateTime.now().toUtc();

    final updateQuery = projectTransactions.update();
    updateQuery.where((pt) => pt.id.equals(updatedEntity.id));

    final results = await updateQuery.writeReturning(
      ProjectTransactionModelX.fromEntity(
        updatedEntity,
      ).toValidCompanion(updatedAt: now),
    );

    return results.firstOrNull?.toEntity();
  }

  Future<ProjectTransaction?> deleteById(int id) async {
    final deleteQuery = projectTransactions.delete();
    deleteQuery.where((pt) => pt.id.equals(id));

    final results = await deleteQuery.goAndReturn();

    return results.firstOrNull?.toEntity();
  }
}
