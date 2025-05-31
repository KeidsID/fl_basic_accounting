import "package:freezed_annotation/freezed_annotation.dart";

import "package:app/libs/decorators/freezed.dart";
export "package:app/libs/decorators/freezed.dart" show dateTimeProp;

part "entity.freezed.dart";
part "entity.g.dart";

@Freezed(copyWith: false)
@JsonSerializable()
class Entity with _$Entity {
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

  Entity({this.id = 0, DateTime? createdAt, DateTime? updatedAt}) {
    final now = DateTime.now().toUtc();

    this.createdAt = createdAt?.toUtc() ?? now;
    this.updatedAt = updatedAt?.toUtc() ?? now;
  }

  factory Entity.fromJson(Map<String, dynamic> json) => _$EntityFromJson(json);

  Map<String, dynamic> toJson() => _$EntityToJson(this);
}
