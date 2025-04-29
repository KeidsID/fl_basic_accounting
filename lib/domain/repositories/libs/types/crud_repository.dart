import "package:app/domain/entities.dart";

/// Base class for repositories that may need CRUD methods.
abstract class CrudRepository<T extends Entity> {
  const CrudRepository();

  /// Store [entity] into database.
  Future<T> create(T entity);

  /// Return entity by [id].
  Future<T?> readById(int id);

  /// Return list of entities from database.
  Future<List<T>> readAll();

  /// Update entity with [updatedEntity] values.
  ///
  /// Make use of [Entity.copyWith] method to make sure the [updatedEntity] to
  /// safely clone the [Entity.id] for update purpose.
  Future<T?> update(T updatedEntity);

  /// Delete entity by [id].
  ///
  /// Return deleted entity.
  Future<T?> delete(int id);
}
