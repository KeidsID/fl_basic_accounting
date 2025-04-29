import "package:riverpod_annotation/riverpod_annotation.dart";

import "package:app/domain/entities.dart";
import "package:app/service_locator.dart";
import "package:app/use_cases.dart";

part "projects_provider.g.dart";

@riverpod
class Projects extends _$Projects {
  @override
  Stream<List<Project>> build() {
    return _getProjects();
  }

  Stream<List<Project>> _getProjects() {
    return ServiceLocator.find<GetProjectsUseCase>().execute();
  }

  Future<Project> create({required String name, String? description}) {
    state = const AsyncLoading();

    return ServiceLocator.find<CreateProjectUseCase>().execute(
      Project(name: name, description: description),
    );
  }

  Future<Project?> updateProject(Project updatedEntity) {
    state = const AsyncLoading();

    return ServiceLocator.find<UpdateProjectUseCase>().execute(updatedEntity);
  }

  Future<Project?> deleteById(int id) {
    state = const AsyncLoading();

    return ServiceLocator.find<DeleteProjectUseCase>().execute(id);
  }
}
