import "package:app/domain/entities.dart";
import "package:injectable/injectable.dart";

import "package:app/domain/repositories.dart";
import "package:app/use_cases/libs/types.dart";

@singleton
class CreateProjectTransactionUseCase
    implements UseCase<ProjectTransaction, ProjectTransaction> {
  final ProjectTransactionsRepository _projectTransactionsRepository;

  const CreateProjectTransactionUseCase(this._projectTransactionsRepository);

  @override
  Future<ProjectTransaction> execute(ProjectTransaction entity) {
    return _projectTransactionsRepository.create(entity);
  }
}
