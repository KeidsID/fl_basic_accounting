import "package:drift/drift.dart";

/// Contains [id] as primary key with [createdAt] and [updatedAt] as timestamps.
///
/// Should be used on every table definitions.
///
/// Incase you need custom primary key, you can use [TimestampsTableColumns]
/// mixin that omits [id] column.
mixin DefaultTableColumns on Table {
  late final id = integer().autoIncrement()();
  late final createdAt = dateTime().withDefault(currentDateAndTime)();
  late final updatedAt = dateTime().withDefault(currentDateAndTime)();
}

/// Contains [createdAt] and [updatedAt] as timestamps.
mixin TimestampsTableColumns on Table {
  late final createdAt = dateTime().withDefault(currentDateAndTime)();
  late final updatedAt = dateTime().withDefault(currentDateAndTime)();
}
