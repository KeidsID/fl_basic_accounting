import "package:freezed_annotation/freezed_annotation.dart";

import "package:app/domain/entities.dart";
import "package:app/domain/repositories/libs/types.dart";

part "projects_repository.freezed.dart";

abstract interface class ProjectsRepository
    extends CrudRepository<Project, ProjectsRepositoryReadQuery> {
  // Should add other methods to handle other use cases.
}

@freezed
sealed class ProjectsRepositoryReadQuery with _$ProjectsRepositoryReadQuery {
  const factory ProjectsRepositoryReadQuery({
    /// Whether to include [Project.totalCash] in the results.
    /// 
    /// Defaults to `true`.
    @Default(true) bool includeTotalCash,
  }) = _ProjectsRepositoryReadQuery;
}
