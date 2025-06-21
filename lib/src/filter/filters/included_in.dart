import 'package:meta/meta.dart';
import 'package:postgrest/postgrest.dart';
import 'package:typesafe_postgrest/typesafe_postgrest.dart';

/// {@template typesafe_postgrest.PgIncludedInFilter}
///
/// Column is in an array.
///
/// A filter that only matches rows where the column is found in the specified
/// [values].
///
/// `values`: The list to filter with.
///
/// {@endtemplate}
class PgIncludedInFilter<TableType, T> extends PgFilter<TableType> {
  /// {@macro typesafe_postgrest.PgIncludedInFilter}
  @internal
  const PgIncludedInFilter(this.column, this.values, super.previousFilter);

  /// The column to filter by.
  final PgFilterColumn<TableType, dynamic, T> column;

  /// The list to filter with.
  final List<T> values;

  @override
  PostgrestFilterBuilder<P> build<P>(PostgrestFilterBuilder<P> builder) =>
      builder.inFilter(column.filterPattern, values);

  @override
  PgFilter<TableType> withPreviousFilter(PgFilter<TableType> previousFilter) =>
      PgIncludedInFilter(column, values, previousFilter);
}
