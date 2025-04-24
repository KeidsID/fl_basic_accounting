import "package:drift/drift.dart";

import "../libs/types.dart";

@DataClassName("ProjectModel")
class Projects extends Table with DefaultTableColumns {
  late final name = text()();
  late final description = text().nullable()();
}