import "package:freezed_annotation/freezed_annotation.dart";

import "package:app/domain/entities/libs/types.dart";

part "project.freezed.dart";
part "project.g.dart";

@freezed
@JsonSerializable()
final class Project extends Entity with _$Project {
  @override
  final String name;

  @override
  final String? description;

  Project({
    super.id,
    super.createdAt,
    super.updatedAt,
    required this.name,
    this.description,
  });

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ProjectToJson(this);
}
