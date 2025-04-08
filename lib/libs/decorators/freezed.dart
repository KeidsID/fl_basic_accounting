import "package:freezed_annotation/freezed_annotation.dart";

/// {@template app.libs.decorators.DateTimeProp}
/// Decorator to handle freezed json serialization for [DateTime] property.
/// {@endtemplate}
const dateTimeProp = DateTimeProp();

/// {@macro app.libs.decorators.DateTimeProp}
final class DateTimeProp implements JsonConverter<DateTime, String> {
  /// {@macro app.libs.decorators.DateTimeProp}
  const DateTimeProp();

  @override
  DateTime fromJson(String json) {
    return DateTime.parse(json);
  }

  @override
  String toJson(DateTime object) {
    return object.toIso8601String();
  }
}

/// {@template app.libs.decorators.NullableDateTimeProp}
/// Decorator to handle freezed json serializable for nullable [DateTime]
/// property.
/// {@endtemplate}
const nullableDateTimeProp = NullableDateTimeProp();

/// {@macro app.libs.decorators.NullableDateTimeProp}
final class NullableDateTimeProp implements JsonConverter<DateTime?, String?> {
  /// {@macro app.libs.decorators.NullableDateTimeProp}
  const NullableDateTimeProp();

  @override
  DateTime? fromJson(String? json) {
    return DateTime.tryParse("$json");
  }

  @override
  String? toJson(DateTime? object) {
    return object?.toIso8601String();
  }
}
