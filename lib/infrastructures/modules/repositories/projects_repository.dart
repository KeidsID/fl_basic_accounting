import "package:injectable/injectable.dart";

import "package:app/domain/entities.dart";
import "package:app/domain/repositories.dart";
import "package:app/infrastructures/libs/data.dart";

@LazySingleton(as: ProjectsRepository)
final class ProjectsRepositoryImpl implements ProjectsRepository {
  final ProjectsLocalData _projectsLocalData;

  const ProjectsRepositoryImpl(this._projectsLocalData);

  @override
  Future<Project> create(Project entity) async {
    return _projectsLocalData.create(entity);
  }

  @override
  Future<Project?> readById(
    int id, [
    ProjectsRepositoryReadQuery query = const ProjectsRepositoryReadQuery(),
  ]) async {
    final result = await _projectsLocalData.readById(
      id,
      includeTotalCash: query.includeTotalCash,
    );

    return result;
  }

  @override
  Future<List<Project>> readAll([
    ProjectsRepositoryReadQuery query = const ProjectsRepositoryReadQuery(),
  ]) {
    return _projectsLocalData
        .readAll(includeTotalCash: query.includeTotalCash)
        .get();
  }

  @override
  Stream<List<Project>> readAllStream([
    ProjectsRepositoryReadQuery query = const ProjectsRepositoryReadQuery(),
  ]) {
    return _projectsLocalData
        .readAll(includeTotalCash: query.includeTotalCash)
        .watch();
  }

  @override
  Future<Project?> update(Project updatedEntity) async {
    return _projectsLocalData.updateProject(updatedEntity);
  }

  @override
  Future<Project?> deleteById(int id) => _projectsLocalData.deleteById(id);
}
