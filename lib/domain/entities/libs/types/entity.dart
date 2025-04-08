import "package:freezed_annotation/freezed_annotation.dart";

import "package:app/libs/decorators/freezed.dart";
export "package:app/libs/decorators/freezed.dart" show dateTimeProp;

part "entity.freezed.dart";
part "entity.g.dart";

@Freezed(copyWith: false)
@JsonSerializable()
abstract base class Entity with _$Entity {
  Entity({this.id = 0, DateTime? createdAt, DateTime? updatedAt}) {
    final now = DateTime.now().toUtc();

    this.createdAt = createdAt ?? now;
    this.updatedAt = updatedAt ?? now;
  }

  /// Entity identifier.
  ///
  /// Should only be provided if you want to update this entity.
  @override
  final int id;

  /// Timestamp when this entity was created.
  @dateTimeProp
  @override
  late final DateTime createdAt;

  /// Timestamp when this entity was last updated.
  @dateTimeProp
  @override
  late final DateTime updatedAt;

  factory Entity.fromJson(Map<String, dynamic> json) => _$EntityFromJson(json);

  Map<String, dynamic> toJson() => _$EntityToJson(this);

  /// Creates a copy of this entity with the specified properties.
  Object get copyWith;
}
