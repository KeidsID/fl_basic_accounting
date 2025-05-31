import "package:freezed_annotation/freezed_annotation.dart";

import "package:app/domain/entities.dart";
import "package:app/libs/decorators.dart";

part "project.freezed.dart";
part "project.g.dart";

@freezed
@JsonSerializable()
final class Project extends Entity with _$Project {
  @override
  final String name;

  @override
  final String? description;

  /// Sum of all cash in transactions for this project.
  ///
  /// Should be positive value.
  @ignoreJsonSerializable
  @override
  final double totalCashIn;

  /// Sum of all cash out transactions for this project.
  ///
  /// Should be negative value.
  @ignoreJsonSerializable
  @override
  final double totalCashOut;

  Project({
    super.id,
    super.createdAt,
    super.updatedAt,
    required this.name,
    this.description,
    this.totalCashIn = 0.0,
    this.totalCashOut = 0.0,
  }) : assert(totalCashIn >= 0, "totalCashIn should be positive"),
       assert(totalCashOut <= 0, "totalCashOut should be negative");

  /// Sum of all [ProjectTransaction.amount] for this project.
  double get totalCash => totalCashIn + totalCashOut;

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ProjectToJson(this);
}
