import "dart:async";

import "package:app/domain/entities.dart";
import "package:injectable/injectable.dart";

import "package:app/domain/repositories.dart";
import "package:app/use_cases/libs/types.dart";

@singleton
class DeleteProjectUseCase implements UseCase<Project?, int> {
  const DeleteProjectUseCase(this._projectsRepository);

  final ProjectsRepository _projectsRepository;

  @override
  FutureOr<Project?> execute(int projectId) {
    return _projectsRepository.delete(projectId);
  }
}
