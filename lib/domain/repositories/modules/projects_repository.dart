import "package:app/domain/entities.dart";
import "package:app/domain/repositories/libs/types.dart";

abstract interface class ProjectsRepository
    extends CrudRepository<Project, void> {
  // Should add other methods to handle complex use cases.
}
