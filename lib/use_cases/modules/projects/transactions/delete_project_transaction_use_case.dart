import "package:app/domain/entities.dart";
import "package:injectable/injectable.dart";

import "package:app/domain/repositories.dart";
import "package:app/use_cases/libs/types.dart";

@singleton
class DeleteProjectTransactionUseCase
    implements UseCase<ProjectTransaction?, int> {
  final ProjectTransactionsRepository _projectTransactionsRepository;

  const DeleteProjectTransactionUseCase(this._projectTransactionsRepository);

  @override
  Future<ProjectTransaction?> execute(int transactionId) {
    return _projectTransactionsRepository.deleteById(transactionId);
  }
}
