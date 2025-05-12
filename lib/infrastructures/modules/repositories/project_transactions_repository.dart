import "package:injectable/injectable.dart";

import "package:app/domain/entities.dart";
import "package:app/domain/repositories.dart";
import "package:app/infrastructures/libs/data.dart";

@LazySingleton(as: ProjectTransactionsRepository)
final class ProjectTransactionsRepositoryImpl
    implements ProjectTransactionsRepository {
  final ProjectTransactionsLocalData _projectTransactionsLocalData;

  const ProjectTransactionsRepositoryImpl(this._projectTransactionsLocalData);

  @override
  Future<ProjectTransaction> create(ProjectTransaction entity) async {
    return _projectTransactionsLocalData.create(entity);
  }

  @override
  Future<List<ProjectTransaction>> readAll([
    ProjectTrannsactionsRepositoryReadQuery query =
        const ProjectTrannsactionsRepositoryReadQuery(),
  ]) async {
    return _projectTransactionsLocalData
        .readAll(startDate: query.startDate, endDate: query.endDate)
        .last;
  }

  @override
  Stream<List<ProjectTransaction>> readAllStream([
    ProjectTrannsactionsRepositoryReadQuery query =
        const ProjectTrannsactionsRepositoryReadQuery(),
  ]) async* {
    yield* _projectTransactionsLocalData.readAll(
      startDate: query.startDate,
      endDate: query.endDate,
    );
  }

  @override
  Future<ProjectTransaction?> readById(
    int id, [
    ProjectTrannsactionsRepositoryReadQuery query =
        const ProjectTrannsactionsRepositoryReadQuery(),
  ]) async {
    return _projectTransactionsLocalData.readById(
      id,
      startDate: query.startDate,
      endDate: query.endDate,
    );
  }

  @override
  Future<ProjectTransaction?> update(ProjectTransaction updatedEntity) async {
    return _projectTransactionsLocalData.updateProjectTransaction(
      updatedEntity,
    );
  }

  @override
  Future<ProjectTransaction?> deleteById(int id) async {
    return _projectTransactionsLocalData.deleteById(id);
  }

  @override
  Stream<List<ProjectTransaction>> getProjectTransactions(
    int projectId, [
    ProjectTrannsactionsRepositoryReadQuery query =
        const ProjectTrannsactionsRepositoryReadQuery(),
  ]) async* {
    yield* _projectTransactionsLocalData.readAllByProjectId(
      projectId,
      startDate: query.startDate,
      endDate: query.endDate,
    );
  }

  @override
  Future<({double cashIn, double cashOut})> getProjectTotalCash(
    int projectId, [
    ProjectTrannsactionsRepositoryReadQuery query =
        const ProjectTrannsactionsRepositoryReadQuery(),
  ]) async {
    return _projectTransactionsLocalData.getProjectTotalCash(
      projectId,
      startDate: query.startDate,
      endDate: query.endDate,
    );
  }
}
