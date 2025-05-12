import "package:drift/drift.dart";

import "package:app/domain/entities.dart";

import "../../database.dart";
import "../../tables.dart";
import "../libs/types.dart";

@TableIndex(
  name: "idx_project_transactions",
  columns: {#projectId, #transactionType, #transactionDate},
)
@DataClassName("ProjectTransactionModel")
class ProjectTransactions extends Table with DefaultTableColumns {
  late final projectId = integer().references(Projects, #id)();
  late final amount = real()();
  late final transactionType = textEnum<ProjectTransactionType>()();
  late final description = text()();
  late final transactionDate = dateTime().withDefault(currentDate)();
}

@TableIndex(name: "idx_project_transaction_tags", columns: {#projectId, #name})
@DataClassName("ProjectTransactionTagModel")
class ProjectTransactionTags extends Table with DefaultTableColumns {
  late final projectId = integer().references(Projects, #id)();
  late final name = text()();
  late final description = text().nullable()();

  @override
  List<Set<Column<Object>>>? get uniqueKeys => [
    {projectId, name},
  ];
}

@DataClassName("ProjectTransactionTagRelationModel")
class ProjectTransactionTagRelations extends Table with TimestampsTableColumns {
  late final transactionId = integer().references(ProjectTransactions, #id)();
  late final tagId = integer().references(ProjectTransactionTags, #id)();

  @override
  Set<Column<Object>>? get primaryKey => {transactionId, tagId};
}

extension ProjectTransactionModelX on ProjectTransactionModel {
  static ProjectTransactionModel fromEntity(ProjectTransaction entity) {
    return ProjectTransactionModel(
      id: entity.id,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      projectId: entity.projectId,
      amount: entity.amount,
      transactionType: entity.transactionType,
      description: entity.description,
      transactionDate: entity.transactionDate,
    );
  }

  ProjectTransaction toEntity() {
    return ProjectTransaction(
      id: id,
      createdAt: createdAt,
      updatedAt: updatedAt,
      projectId: projectId,
      amount: amount,
      transactionType: transactionType,
      description: description,
      transactionDate: transactionDate,
    );
  }

  /// {@macro app.infrastructures.libs.data.local.models.toValidCompanion}
  ProjectTransactionsCompanion toValidCompanion({DateTime? updatedAt}) {
    final isCreate = updatedAt == null;

    return toCompanion(true).copyWith(
      id: isCreate ? const Value.absent() : Value(id),
      createdAt: const Value.absent(),
      updatedAt: isCreate ? const Value.absent() : Value(updatedAt),
    );
  }
}

extension ProjectTransactionTagModelX on ProjectTransactionTagModel {
  static ProjectTransactionTagModel fromEntity(ProjectTransactionTag entity) {
    return ProjectTransactionTagModel(
      id: entity.id,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      projectId: entity.projectId,
      name: entity.name,
      description: entity.description,
    );
  }

  ProjectTransactionTag toEntity() {
    return ProjectTransactionTag(
      id: id,
      createdAt: createdAt,
      updatedAt: updatedAt,
      projectId: projectId,
      name: name,
      description: description,
    );
  }

  /// {@macro app.infrastructures.libs.data.local.models.toValidCompanion}
  ProjectTransactionTagsCompanion toValidCompanion({DateTime? updatedAt}) {
    final isCreate = updatedAt == null;

    return toCompanion(true).copyWith(
      id: isCreate ? const Value.absent() : Value(id),
      createdAt: const Value.absent(),
      updatedAt: isCreate ? const Value.absent() : Value(updatedAt),
    );
  }
}
