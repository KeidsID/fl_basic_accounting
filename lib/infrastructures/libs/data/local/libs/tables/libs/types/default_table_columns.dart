import "package:drift/drift.dart";

/// Must be used on every table definitions.
///
/// Contains [id] as primary key with [createdAt] and [updatedAt] as timestamps.
mixin DefaultTableColumns on Table {
  late final id = integer().autoIncrement()();
  late final createdAt = dateTime().withDefault(currentDateAndTime)();
  late final updatedAt = dateTime().withDefault(currentDateAndTime)();
}
