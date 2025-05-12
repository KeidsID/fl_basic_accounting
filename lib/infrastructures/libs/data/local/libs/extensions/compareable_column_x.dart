import "package:drift/drift.dart";

extension CompareableColumnX<T extends Comparable<dynamic>> on Column<T> {
  /// A null-safe alternative to [isBetweenValues].
  ///
  /// Possible outcomes:
  /// * `this >= start`
  /// * `this <= end`
  /// * `this >= start && this <= end`
  ///
  /// At least one of [start] or [end] must be non-null, or else it will only
  /// return [Constant] true.
  Expression<bool> isInRangeOf([T? start, T? end]) {
    final startExp =
        start != null ? isBiggerOrEqualValue(start) : Constant(true);
    final endExp = end != null ? isSmallerOrEqualValue(end) : Constant(true);

    return startExp & endExp;
  }
}
