import 'package:meta/meta.dart';
import 'package:postgrest/postgrest.dart';
import 'package:typesafe_postgrest/typesafe_postgrest.dart';

/// {@template typesafe_postgrest.PgContainsArrayFilter}
///
/// Array column contains every element in a value.
///
/// Only relevant for array columns. A filter that only
/// matches rows where the [column] contains every element appearing in
/// [values].
///
/// `values`: The array of values to filter with.
///
/// {@endtemplate}
class PgContainsArrayFilter<TableType, T> extends PgFilter<TableType> {
  /// {@macro typesafe_postgrest.PgContainsArrayFilter}
  @internal
  const PgContainsArrayFilter(this.column, this.values, super.previousFilter);

  /// The array column to filter on.
  final PgFilterColumn<TableType, List<T>?, List<dynamic>?> column;

  /// The array of values to filter with.
  final List<T> values;

  @override
  @internal
  PostgrestFilterBuilder<P> build<P>(PostgrestFilterBuilder<P> builder) =>
      // .contains is split up into 3 separate PgFilters for arrays, jsonbs and
      // ranges.
      builder.contains(column.filterPattern, column.toJson(values)!);

  @override
  PgFilter<TableType> withPreviousFilter(PgFilter<TableType> previousFilter) =>
      PgContainsArrayFilter(column, values, previousFilter);
}
