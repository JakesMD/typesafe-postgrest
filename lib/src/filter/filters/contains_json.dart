import 'package:meta/meta.dart';
import 'package:postgrest/postgrest.dart';
import 'package:typesafe_postgrest/typesafe_postgrest.dart';

/// {@template typesafe_postgrest.PgContainsJsonFilter}
///
/// Jsonb column contains every element in a value.
///
/// Only relevant for jsonb columns. A filter that only
/// matches rows where the [column] contains every element appearing in
/// [json].
///
/// `json`: The json value to filter with.
///
/// {@endtemplate}
class PgContainsJsonFilter<TableType> extends PgFilter<TableType> {
  /// {@macro typesafe_postgrest.PgContainsJsonFilter}
  @internal
  const PgContainsJsonFilter(this.column, this.json, super.previousFilter);

  /// The array column to filter on.
  final PgFilterColumn<TableType, dynamic, PgJsonMap?> column;

  /// The json value filter with.
  final PgJsonMap json;

  @override
  @internal
  PostgrestFilterBuilder<P> build<P>(PostgrestFilterBuilder<P> builder) =>
      // .contains is split up into 3 separate PgFilters for arrays, jsonbs and
      // ranges.
      builder.contains(column.filterPattern, json);

  @override
  PgFilter<TableType> withPreviousFilter(PgFilter<TableType> previousFilter) =>
      PgContainsJsonFilter(column, json, previousFilter);
}
