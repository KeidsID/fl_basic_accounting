extension NullableStringX on String? {
  /// Return [fallback] if this string is empty or null.
  String fallbackWith(String fallback) {
    return this?.isEmpty ?? true ? fallback : this!;
  }
}
