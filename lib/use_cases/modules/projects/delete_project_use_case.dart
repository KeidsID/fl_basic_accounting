import "package:app/domain/entities.dart";
import "package:injectable/injectable.dart";

import "package:app/domain/repositories.dart";
import "package:app/use_cases/libs/types.dart";

@singleton
class DeleteProjectUseCase implements UseCase<Future<Project?>, int> {
  final ProjectsRepository _projectsRepository;

  const DeleteProjectUseCase(this._projectsRepository);

  @override
  Future<Project?> execute(int projectId) {
    return _projectsRepository.deleteById(projectId);
  }
}
