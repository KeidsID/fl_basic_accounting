import "dart:async";

import "package:app/domain/entities.dart";
import "package:injectable/injectable.dart";

import "package:app/domain/repositories.dart";
import "package:app/use_cases/libs/types.dart";

@singleton
class UpdateProjectUseCase implements UseCase<Project, Project> {
  const UpdateProjectUseCase(this._projectsRepository);

  final ProjectsRepository _projectsRepository;

  @override
  FutureOr<Project> execute(Project updatedEntity) {
    return _projectsRepository.update(updatedEntity);
  }
}
