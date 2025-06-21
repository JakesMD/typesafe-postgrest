import 'package:meta/meta.dart';
import 'package:postgrest/postgrest.dart';
import 'package:typesafe_postgrest/typesafe_postgrest.dart';

/// {@template typesafe_postgrest.PgOverlapsArrayFilter}
///
/// Array with a common element.
///
/// Only relevant for array columns. A filter that only
/// matches rows where the [column] and [values] have an element in common.
///
/// `values`: The array of values to filter with.
///
/// {@endtemplate}
class PgOverlapsArrayFilter<TableType, T> extends PgFilter<TableType> {
  /// {@macro typesafe_postgrest.PgOverlapsArrayFilter}
  @internal
  const PgOverlapsArrayFilter(this.column, this.values, super.previousFilter);

  /// The array column to filter on.
  final PgFilterColumn<TableType, List<T>?, List<dynamic>?> column;

  /// The array of values to filter with.
  final List<T> values;

  @override
  @internal
  PostgrestFilterBuilder<P> build<P>(PostgrestFilterBuilder<P> builder) =>
      // .contains is split up into 2 separate PgFilters for arrays, ranges.
      builder.overlaps(column.filterPattern, column.toJson(values)!);

  @override
  PgFilter<TableType> withPreviousFilter(PgFilter<TableType> previousFilter) =>
      PgOverlapsArrayFilter(column, values, previousFilter);
}
