import "package:app/libs/extensions.dart";
import "package:app/libs/types.dart";

/// Enum to define period of date.
enum DatePeriodFilter {
  /// Start from 7 days ago until today.
  weekly,

  /// Start from 30 days ago until today.
  monthly,

  /// Start from 365 days ago until today.
  annual;

  /// Try parse [dateFilterRecord] into [DatePeriodFilter].
  ///
  /// WIll return `null` if not valid.
  static DatePeriodFilter? tryParse(IntervalRecord<DateTime> dateFilterRecord) {
    if (DatePeriodFilter.weekly.toRecord() == dateFilterRecord) {
      return DatePeriodFilter.weekly;
    } else if (DatePeriodFilter.monthly.toRecord() == dateFilterRecord) {
      return DatePeriodFilter.monthly;
    } else if (DatePeriodFilter.annual.toRecord() == dateFilterRecord) {
      return DatePeriodFilter.annual;
    } else {
      return null;
    }
  }

  /// Parse enum into date [IntervalRecord].
  IntervalRecord<DateTime> toRecord() {
    final now = DateTime.now().toMidnight();

    return switch (this) {
      DatePeriodFilter.weekly => (
        begin: now.subtract(Duration(days: 7)),
        end: now,
      ),
      DatePeriodFilter.monthly => (
        begin: now.subtract(Duration(days: 30)),
        end: now,
      ),
      DatePeriodFilter.annual => (
        begin: now.subtract(Duration(days: 365)),
        end: now,
      ),
    };
  }
}
