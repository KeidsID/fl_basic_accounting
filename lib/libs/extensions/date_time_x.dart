extension DateTimeX on DateTime {
  /// Returns a new [DateTime] with the time set to midnight (00:00:00.000000).
  DateTime toMidnight() {
    return copyWith(
      hour: 0,
      minute: 0,
      second: 0,
      millisecond: 0,
      microsecond: 0,
    );
  }

  /// Returns a new [DateTime.utc] with the time set to midnight
  /// (00:00:00.000000).
  DateTime toUtcMidnight() => toUtc().toMidnight();
}
