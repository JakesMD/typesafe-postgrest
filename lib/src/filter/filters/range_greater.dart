import 'package:meta/meta.dart';
import 'package:postgrest/postgrest.dart';
import 'package:typesafe_postgrest/typesafe_postgrest.dart';

/// {@template typesafe_postgrest.PgRangeGreaterFilter}
///
/// Greater than a range.
///
/// Only relevant for range columns. A filter that only
/// matches rows where every element in the [column] is greater than any
/// element in range from [lowerBound] to [upperBound].
///
/// `lowerBound`: The lower range value to filter with.
///
/// `upperBound`: The upper range value to filter with.
///
/// `rangeType`: The range type to filter with.
///
/// {@endtemplate}
class PgRangeGreaterFilter<TableType, T extends Object>
    extends PgFilter<TableType> {
  /// {@macro typesafe_postgrest.PgRangeGreaterFilter}
  @internal
  const PgRangeGreaterFilter(
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
      builder.rangeGt(
        column.filterPattern,
        rangeType.patternFromBounds(upperBound, lowerBound),
      );

  @override
  PgFilter<TableType> withPreviousFilter(PgFilter<TableType> previousFilter) =>
      PgRangeGreaterFilter(
        column,
        lowerBound,
        upperBound,
        rangeType,
        previousFilter,
      );
}
