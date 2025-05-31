import "package:riverpod_annotation/riverpod_annotation.dart";

import "package:app/domain/entities.dart";
import "package:app/libs/types.dart";
import "package:app/service_locator.dart";
import "package:app/use_cases.dart";

part "project_transactions_provider.g.dart";

@riverpod
class ProjectTransactions extends _$ProjectTransactions {
  @override
  Stream<List<ProjectTransaction>> build(
    int projectId, {
    IntervalRecord<DateTime>? transactionDateFilter,
  }) {
    return ServiceLocator.find<GetProjectTransactionsUseCase>().execute(
      GetProjectTransactionsUseCaseOptions(
        projectId: projectId,
        startDate: transactionDateFilter?.begin,
        endDate: transactionDateFilter?.end,
      ),
    );
  }

  Future<void> createTransaction(ProjectTransaction entity) async {
    state = AsyncLoading();

    await ServiceLocator.find<CreateProjectTransactionUseCase>().execute(
      entity,
    );
  }

  Future<void> updateTransaction(ProjectTransaction updatedEntity) async {
    state = AsyncLoading();

    await ServiceLocator.find<UpdateProjectTransactionUseCase>().execute(
      updatedEntity,
    );
  }

  Future<void> deleteTransaction(int transactionId) async {
    state = AsyncLoading();

    await ServiceLocator.find<DeleteProjectTransactionUseCase>().execute(
      transactionId,
    );
  }
}
