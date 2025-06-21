import 'package:meta/meta.dart';
import 'package:postgrest/postgrest.dart';
import 'package:typesafe_postgrest/typesafe_postgrest.dart';

/// {@template typesafe_postgrest.PgRangeAdjacentFilter}
///
/// Mutually exclusive to a range.
///
/// Only relevant for range columns. A filter that only
/// matches rows where the [column] is is mutually exclusive to the range from
/// [lowerBound] to [upperBound] and there can be no element between the two
/// ranges.
///
/// `lowerBound`: The lower range value to filter with.
///
/// `upperBound`: The upper range value to filter with.
///
/// `rangeType`: The range type to filter with.
///
/// {@endtemplate}
class PgRangeAdjacentFilter<TableType, T extends Object>
    extends PgFilter<TableType> {
  /// {@macro typesafe_postgrest.PgRangeAdjacentFilter}
  @internal
  const PgRangeAdjacentFilter(
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
      builder.rangeAdjacent(
        column.filterPattern,
        rangeType.patternFromBounds(upperBound, lowerBound),
      );

  @override
  PgFilter<TableType> withPreviousFilter(PgFilter<TableType> previousFilter) =>
      PgRangeAdjacentFilter(
        column,
        lowerBound,
        upperBound,
        rangeType,
        previousFilter,
      );
}
