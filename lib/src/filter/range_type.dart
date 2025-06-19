import 'package:meta/meta.dart';

/// Represents the type of a range.
///
/// This is used to determine the pattern for a range filter.
enum PgRangeType {
  /// Inclusive lower bound and inclusive upper bound.
  ///
  /// Example: [1, 10]
  inclusiveInclusive,

  /// Inclusive lower bound and exclusive upper bound.
  ///
  /// Example: [1, 10)
  inclusiveExclusive,

  /// Exclusive lower bound and inclusive upper bound.
  ///
  /// Example: (1, 10]
  exclusiveInclusive,

  /// Exclusive lower bound and exclusive upper bound.
  ///
  /// Example: (1, 10)
  exclusiveExclusive;

  /// Returns the filter pattern for the range type with the provided bounds.
  @internal
  String patternFromBounds<T extends Object>(T upperBound, T lowerBound) {
    switch (this) {
      case PgRangeType.inclusiveInclusive:
        return '[$lowerBound,$upperBound]';
      case PgRangeType.inclusiveExclusive:
        return '[$lowerBound,$upperBound)';
      case PgRangeType.exclusiveInclusive:
        return '($lowerBound,$upperBound]';
      case PgRangeType.exclusiveExclusive:
        return '($lowerBound,$upperBound)';
    }
  }
}
