import 'package:meta/meta.dart';
import 'package:postgrest/postgrest.dart';
import 'package:typesafe_postgrest/typesafe_postgrest.dart';

/// {@template typesafe_postgrest.PgOverlapsRangeFilter}
///
/// Range column contains every element in a value.
///
/// Only relevant for range columns. A filter that only
/// matches rows where the [column] contains the range from
/// [lowerBound] to [upperBound].
///
/// `lowerBound`: The lower range value to filter with.
///
/// `upperBound`: The upper range value to filter with.
///
/// `rangeType`: The range type to filter with.
///
/// {@endtemplate}
class PgOverlapsRangeFilter<TableType, T extends Object>
    extends PgFilter<TableType> {
  /// {@macro typesafe_postgrest.PgOverlapsRangeFilter}
  @internal
  const PgOverlapsRangeFilter(
    this.column,
    this.lowerBound,
    this.upperBound,
    this.rangeType,
    super.previousFilter,
  );

  /// The range column to filter on.
  final PgFilterColumn<TableType, dynamic, dynamic> column;

  /// The lower range value to filter with.
  final T lowerBound;

  /// The upper range value to filter with.
  final T upperBound;

  /// The range type to filter with.
  final PgRangeType rangeType;

  @override
  @internal
  PostgrestFilterBuilder<P> build<P>(PostgrestFilterBuilder<P> builder) =>
      // .contains is split up into 2 separate PgFilters for arrays, ranges.
      builder.overlaps(
        column.filterPattern,
        rangeType.patternFromBounds(upperBound, lowerBound),
      );

  @override
  PgFilter<TableType> withPreviousFilter(PgFilter<TableType> previousFilter) =>
      PgOverlapsRangeFilter(
        column,
        lowerBound,
        upperBound,
        rangeType,
        previousFilter,
      );
}
