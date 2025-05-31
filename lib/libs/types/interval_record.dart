/// A [Record] representing an interval with optional [begin] and [end] values.
///
/// At least one of [begin] or [end] must be non-null.
///
/// This type is suitable for defining range conditions such as:
///
/// * `begin <= x`
/// * `x <= end`
/// * `begin <= x <= end`
///
/// Try [IntervalRecordX.validate] extension to validate a value against the
/// interval.
typedef IntervalRecord<T extends Comparable> = ({T? begin, T? end});

extension IntervalRecordX<T extends Comparable> on IntervalRecord {
  /// Validate [value] against the interval.
  /// 
  /// At least one of [begin] or [end] on the record must be non-null, or else
  /// this method will always return true.
  bool validate(T value) {
    final isOnBeginRange = (begin?.compareTo(value) ?? 0) <= 0;
    final isOnEndRange = (end?.compareTo(value) ?? 0) >= 0;

    return isOnBeginRange && isOnEndRange;
  }
}
