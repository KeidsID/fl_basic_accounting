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
    final result = await _projectsLocalData.create(
      name: entity.name,
      description: entity.description,
    );

    return result.toEntity();
  }

  @override
  Future<Project?> delete(int id) async {
    final result = await _projectsLocalData.deleteById(id);

    return result?.toEntity();
  }

  @override
  Future<List<Project>> readAll() async {
    final results = await _projectsLocalData.readAll();

    return results.map((e) => e.toEntity()).toList();
  }

  @override
  Future<Project?> readById(int id) async {
    final result = await _projectsLocalData.readById(id);

    return result?.toEntity();
  }

  @override
  Future<Project?> update(Project updatedEntity) async {
    final Project(:id, :name, :description) = updatedEntity;

    final result = await _projectsLocalData.updateById(
      id,
      name: name,
      description: description,
    );

    return result?.toEntity();
  }

  @override
  Stream<List<Project>> readAllAsStream() {
    return _projectsLocalData.readAllAsStream().map(
      (results) => results.map((e) => e.toEntity()).toList(),
    );
  }
}
