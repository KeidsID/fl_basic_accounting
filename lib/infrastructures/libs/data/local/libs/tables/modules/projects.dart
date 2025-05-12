import "package:drift/drift.dart";

import "package:app/domain/entities.dart";

import "../../database.dart";
import "../libs/types.dart";

@TableIndex(name: "idx_projects", columns: {#name})
@DataClassName("ProjectModel")
class Projects extends Table with DefaultTableColumns {
  late final name = text()();
  late final description = text().nullable()();
}

extension ProjectModelX on ProjectModel {
  static ProjectModel fromEntity(Project entity) {
    return ProjectModel(
      id: entity.id,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      name: entity.name,
      description: entity.description,
    );
  }

  Project toEntity() {
    return Project(
      id: id,
      createdAt: createdAt,
      updatedAt: updatedAt,
      name: name,
      description: description,
    );
  }

  /// {@template app.infrastructures.libs.data.local.models.toValidCompanion}
  /// Convert to companion while ommitting fields that are not supposed to be
  /// changed.
  ///
  /// Provide [updatedAt] if it not supposed to be new entity.
  /// {@endtemplate}
  ProjectsCompanion toValidCompanion({DateTime? updatedAt}) {
    final isCreate = updatedAt == null;

    return toCompanion(true).copyWith(
      id: isCreate ? const Value.absent() : Value(id),
      createdAt: const Value.absent(),
      updatedAt: isCreate ? const Value.absent() : Value(updatedAt),
    );
  }
}
