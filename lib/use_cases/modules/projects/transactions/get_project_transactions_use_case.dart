import "package:freezed_annotation/freezed_annotation.dart";
import "package:injectable/injectable.dart";

import "package:app/domain/entities.dart";
import "package:app/domain/repositories.dart";
import "package:app/use_cases/libs/types.dart";

part "get_project_transactions_use_case.freezed.dart";

@singleton
class GetProjectTransactionsUseCase
    implements
        StreamUseCase<
          List<ProjectTransaction>,
          GetProjectTransactionsUseCaseOptions
        > {
  final ProjectTransactionsRepository _projectTransactionsRepository;

  const GetProjectTransactionsUseCase(this._projectTransactionsRepository);

  @override
  Stream<List<ProjectTransaction>> execute(
    GetProjectTransactionsUseCaseOptions options,
  ) {
    return _projectTransactionsRepository
        .readAllByProjectId(
          options.projectId,
          ProjectTrannsactionsRepositoryReadQuery(
            startDate: options.startDate,
            endDate: options.endDate,
          ),
        )
        .asyncMap((results) async {
          if (results.isEmpty) return results;

          final [first, ...rest] = results;

          final (:cashIn, :cashOut) = await _projectTransactionsRepository
              .getProjectTotalCash(
                first.projectId,
                ProjectTrannsactionsRepositoryReadQuery(
                  endDate: first.transactionDate.subtract(Duration(days: 1)),
                ),
              );
          final previousTotalCash = cashIn - cashOut;

          return [
            first.copyWith(previousTotalCash: previousTotalCash),
            ...rest,
          ];
        });
  }
}

@freezed
sealed class GetProjectTransactionsUseCaseOptions
    with _$GetProjectTransactionsUseCaseOptions {
  const factory GetProjectTransactionsUseCaseOptions({
    required int projectId,
    DateTime? startDate,
    DateTime? endDate,
  }) = _GetProjectTransactionsUseCaseOptions;
}
