import "package:freezed_annotation/freezed_annotation.dart";

import "package:app/domain/entities.dart";
import "package:app/domain/repositories/libs/types.dart";

part "project_transactions_repository.freezed.dart";

abstract interface class ProjectTransactionsRepository
    extends
        CrudRepository<
          ProjectTransaction,
          ProjectTrannsactionsRepositoryReadQuery
        > {
  /// Get all transactions for a project.
  ///
  /// Can be filtered with [query].
  Stream<List<ProjectTransaction>> getProjectTransactions(
    int projectId, [
    ProjectTrannsactionsRepositoryReadQuery query =
        const ProjectTrannsactionsRepositoryReadQuery(),
  ]);

  /// Get pair of cash in and cash out transactions total for a project.
  ///
  /// So cash total can be calculated as: `cashIn - cashOut`
  ///
  /// Can be filtered with [query].
  ///
  /// Supposed to be better performance than calculating it from
  /// [getProjectTransactions].
  Future<({double cashIn, double cashOut})> getProjectTotalCash(
    int projectId, [
    ProjectTrannsactionsRepositoryReadQuery query =
        const ProjectTrannsactionsRepositoryReadQuery(),
  ]);
}

@freezed
sealed class ProjectTrannsactionsRepositoryReadQuery
    with _$ProjectTrannsactionsRepositoryReadQuery {
  const factory ProjectTrannsactionsRepositoryReadQuery({
    DateTime? startDate,
    DateTime? endDate,
  }) = _ProjectTrannsactionsRepositoryReadQuery;
}
