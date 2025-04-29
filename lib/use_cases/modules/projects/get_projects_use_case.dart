import "package:app/domain/entities.dart";
import "package:injectable/injectable.dart";

import "package:app/domain/repositories.dart";
import "package:app/use_cases/libs/types.dart";

@singleton
class GetProjectsUseCase implements UseCase<Stream<List<Project>>, void> {
  const GetProjectsUseCase(this._projectsRepository);

  final ProjectsRepository _projectsRepository;

  @override
  Stream<List<Project>> execute([void params]) {
    return _projectsRepository.readAllAsStream();
  }
}
