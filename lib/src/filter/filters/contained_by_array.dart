import 'package:meta/meta.dart';
import 'package:postgrest/postgrest.dart';
import 'package:typesafe_postgrest/typesafe_postgrest.dart';

/// {@template typesafe_postgrest.PgContainedByArrayFilter}
///
/// Array column contained by array value.
///
/// Only relevant for array columns. A filter that only
/// matches rows where the every element appearing in [column] is contained by
/// [value].
///
/// `value`: The array value to filter with.
///
/// {@endtemplate}
class PgContainedByArrayFilter<TableType, T> extends PgFilter<TableType> {
  /// {@macro typesafe_postgrest.PgContainedByArrayFilter}
  @internal
  const PgContainedByArrayFilter(
    this.column,
    this.value,
    super.previousFilter,
  );

  /// The array column to filter on.
  final PgFilterColumn<TableType, List<T>?, List<dynamic>?> column;

  /// The array value to filter with.
  final List<T> value;

  @override
  @internal
  PostgrestFilterBuilder<P> build<P>(PostgrestFilterBuilder<P> builder) =>
      // .containedBy is split up into 3 separate PgFilters for arrays, jsonbs
      // and ranges.
      builder.containedBy(column.filterPattern, column.toJson(value)!);

  @override
  PgFilter<TableType> withPreviousFilter(PgFilter<TableType> previousFilter) =>
      PgContainedByArrayFilter(column, value, previousFilter);
}
