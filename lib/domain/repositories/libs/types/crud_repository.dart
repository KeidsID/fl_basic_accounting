import "package:app/domain/entities.dart";

/// Base class for repositories that may need CRUD methods.
///
/// With [ReadQuery] generic type, you can use it to pass custom query on
/// read methods for sorting, filtering, etc.
abstract class CrudRepository<T extends Entity, ReadQuery> {
  const CrudRepository();

  /// Store [entity] into database.
  Future<T> create(T entity);

  /// Return entity by [id].
  Future<T?> readById(int id, [ReadQuery query]);

  /// Return list of entities from database.
  Future<List<T>> readAll([ReadQuery query]);

  /// [readAll] that returns a [Stream] instead of [Future].
  Stream<List<T>> readAllStream([ReadQuery query]);

  /// Update entity with [updatedEntity] values.
  ///
  /// Make use of `copyWith` method without modify the [Entity.id] to safely
  /// update the desired entity.
  Future<T?> update(T updatedEntity);

  /// Delete entity by [id].
  ///
  /// Return deleted entity.
  Future<T?> deleteById(int id);
}
