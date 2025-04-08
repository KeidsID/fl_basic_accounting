import "dart:async";

import "package:app/domain/entities.dart";

/// Base class for repositories that may need CRUD methods.
abstract class CrudRepository<T extends Entity> {
  const CrudRepository();

  /// Store [entity] into database.
  FutureOr<T> create(T entity);

  /// Return entity by [id].
  FutureOr<T> readById(int id);

  /// Return list of entities from database.
  FutureOr<List<T>> readAll();

  /// Update entity with [updatedEntity] values.
  ///
  /// Make use of [Entity.copyWith] method to make sure the [updatedEntity] to
  /// safely clone the [Entity.id] for update purpose.
  FutureOr<T> update(T updatedEntity);

  /// Delete entity by [id].
  ///
  /// Return deleted entity.
  FutureOr<T> delete(int id);
}
