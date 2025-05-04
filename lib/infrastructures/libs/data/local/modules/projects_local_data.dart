import "package:drift/drift.dart";
import "package:injectable/injectable.dart";

import "package:app/domain/entities.dart";

import "../libs/database.dart";
import "../libs/tables.dart";

part "projects_local_data.g.dart";

@lazySingleton
@DriftAccessor(tables: [Projects])
class ProjectsLocalData extends DatabaseAccessor<AppDatabase>
    with _$ProjectsLocalDataMixin {
  ProjectsLocalData(super.db);

  Future<ProjectModel> create({
    required String name,
    String? description,
  }) async {
    final Value<String?> descriptionValue =
        description?.isNotEmpty ?? true ? Value(description) : Value(null);

    return projects.insertReturning(
      ProjectsCompanion.insert(name: name, description: descriptionValue),
    );
  }

  SimpleSelectStatement<$ProjectsTable, ProjectModel> readAll() {
    return projects.select();
  }

  Future<ProjectModel?> readById(int id) async {
    return (projects.select()..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  Future<ProjectModel?> updateById(
    int id, {
    String? name,
    String? description,
  }) async {
    final updatedAt = DateTime.now().toUtc();

    final Value<String> nameValue = name == null ? Value.absent() : Value(name);
    final Value<String?> descriptionValue =
        description?.isNotEmpty ?? true ? Value(description) : Value(null);

    final results = await (projects.update()..where((e) => e.id.equals(id)))
        .writeReturning(
          ProjectsCompanion(
            name: nameValue,
            description: descriptionValue,
            updatedAt: Value(updatedAt),
          ),
        );

    return results.firstOrNull;
  }

  Future<ProjectModel?> deleteById(int id) async {
    final results =
        await (projects.delete()..where((e) => e.id.equals(id))).goAndReturn();

    return results.firstOrNull;
  }
}

extension ProjectModelX on ProjectModel {
  Project toEntity() {
    return Project(
      id: id,
      name: name,
      description: description,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
