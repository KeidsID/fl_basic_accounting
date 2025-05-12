import "package:drift/drift.dart";
import "package:injectable/injectable.dart";

import "package:app/domain/entities.dart";
import "../libs/database.dart";
import "../libs/tables.dart";

part "project_transaction_tags_local_data.g.dart";

typedef _ReadQueryWhereFilter =
    Expression<bool> Function(
      $ProjectTransactionTagsTable projectTransactionTags,
    );

@lazySingleton
@DriftAccessor(tables: [ProjectTransactionTags, ProjectTransactionTagRelations])
class ProjectTransactionTagsLocalData extends DatabaseAccessor<AppDatabase>
    with _$ProjectTransactionTagsLocalDataMixin {
  ProjectTransactionTagsLocalData(super.db);

  Future<ProjectTransactionTag> create(ProjectTransactionTag entity) async {
    final result = await projectTransactionTags.insertReturning(
      ProjectTransactionTagModelX.fromEntity(entity).toValidCompanion(),
    );

    return result.toEntity();
  }

  /// Insert [tagEntity] on [ProjectTransaction.tags] via MtM relation.
  Future<ProjectTransactionTagRelationModel> createRelation(
    ProjectTransaction transactionEntity,
    ProjectTransactionTag tagEntity,
  ) async {
    final result = await projectTransactionTagRelations.insertReturning(
      ProjectTransactionTagRelationsCompanion.insert(
        transactionId: transactionEntity.id,
        tagId: tagEntity.id,
      ),
    );

    return result;
  }

  Selectable<ProjectTransactionTag> _readQuery({
    _ReadQueryWhereFilter? whereFilter,
  }) {
    final query = projectTransactionTags.select();
    if (whereFilter != null) query.where((ptt) => whereFilter(ptt));

    return query.map((row) => row.toEntity());
  }

  Selectable<ProjectTransactionTag> readAll() {
    return _readQuery();
  }

  Future<ProjectTransactionTag?> readById(int id) {
    return _readQuery(
      whereFilter: (ptt) => ptt.id.equals(id),
    ).getSingleOrNull();
  }

  Future<ProjectTransactionTag?> updateTransactionTag(
    ProjectTransactionTag updatedEntity,
  ) async {
    final now = DateTime.now().toUtc();

    final updateQuery = projectTransactionTags.update();
    updateQuery.where((ptt) => ptt.id.equals(updatedEntity.id));

    final results = await updateQuery.writeReturning(
      ProjectTransactionTagModelX.fromEntity(
        updatedEntity,
      ).toValidCompanion(updatedAt: now),
    );

    return results.firstOrNull?.toEntity();
  }

  Future<ProjectTransactionTag?> deleteById(int id) async {
    final deleteQuery = projectTransactionTags.delete();
    deleteQuery.where((ptt) => ptt.id.equals(id));

    final results = await deleteQuery.goAndReturn();

    return results.firstOrNull?.toEntity();
  }
}
