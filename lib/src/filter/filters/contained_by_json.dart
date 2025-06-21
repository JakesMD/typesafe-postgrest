import 'package:meta/meta.dart';
import 'package:postgrest/postgrest.dart';
import 'package:typesafe_postgrest/typesafe_postgrest.dart';

/// {@template typesafe_postgrest.PgContainedByJsonFilter}
///
/// Jsonb column contained by json value.
///
/// Only relevant for jsonb columns. A filter that only
/// matches rows where the every element appearing in [column] is contained by
/// [value].
///
/// `value`: The json value to filter with.
///
/// {@endtemplate}
class PgContainedByJsonFilter<TableType> extends PgFilter<TableType> {
  /// {@macro typesafe_postgrest.PgContainedByJsonFilter}
  @internal
  const PgContainedByJsonFilter(this.column, this.value, super.previousFilter);

  /// The json column to filter on.
  final PgFilterColumn<TableType, dynamic, PgJsonMap?> column;

  /// The json value filter with.
  final PgJsonMap value;

  @override
  @internal
  PostgrestFilterBuilder<P> build<P>(PostgrestFilterBuilder<P> builder) =>
      // .containedBy is split up into 3 separate PgFilters for arrays, jsonbs
      // and ranges.
      builder.containedBy(column.filterPattern, value);

  @override
  PgFilter<TableType> withPreviousFilter(PgFilter<TableType> previousFilter) =>
      PgContainedByJsonFilter(column, value, previousFilter);
}
