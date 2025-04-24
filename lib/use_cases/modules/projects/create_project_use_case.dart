import "package:app/domain/entities.dart";
import "package:injectable/injectable.dart";

import "package:app/domain/repositories.dart";
import "package:app/use_cases/libs/types.dart";

@singleton
class CreateProjectUseCase implements UseCase<Future<Project>, Project> {
  const CreateProjectUseCase(this._projectsRepository);

  final ProjectsRepository _projectsRepository;

  @override
  Future<Project> execute(Project entity) {
    return _projectsRepository.create(entity);
  }
}
